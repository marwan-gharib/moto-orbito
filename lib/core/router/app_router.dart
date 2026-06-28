import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/supabase/supabase_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/no_internet_screen.dart';
import 'deep_link_intent.dart';
import 'routes.dart';

final class AppRouter {
  AppRouter(
    this._supabaseService,
    this._intentStore,
    this._supabaseInitialized,
  );

  final SupabaseService _supabaseService;
  final DeepLinkIntentStore _intentStore;
  final bool Function() _supabaseInitialized;

  GoRouter router() {
    return GoRouter(
      initialLocation: AppRoute.home,
      routes: [
        GoRoute(
          path: AppRoute.splash,
          name: AppRoute.splash,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.noConnection,
          name: AppRoute.noConnection,
          builder: (_, _) => const NoInternetScreen(),
        ),
        GoRoute(
          path: AppRoute.onboarding,
          name: AppRoute.onboarding,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.welcome,
          name: AppRoute.welcome,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.signUp,
          name: AppRoute.signUp,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.verifyEmail,
          name: AppRoute.verifyEmail,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.login,
          name: AppRoute.login,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.phoneOtp,
          name: AppRoute.phoneOtp,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.forgotPassword,
          name: AppRoute.forgotPassword,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.profileSetup,
          name: AppRoute.profileSetup,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: AppRoute.joinGroup,
          name: AppRoute.joinGroup,
          builder: (_, _) => const SizedBox.shrink(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return Scaffold(
              body: navigationShell,
              bottomNavigationBar: BottomNavBar(
                navigationShell: navigationShell,
              ),
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.home,
                  name: AppRoute.home,
                  builder: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.groups,
                  name: AppRoute.groups,
                  builder: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/live-map',
                  name: '/live-map',
                  builder: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.maintenance,
                  name: AppRoute.maintenance,
                  builder: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoute.profile,
                  name: AppRoute.profile,
                  builder: (_, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ),
        ..._detailRoutes(),
      ],
      redirect: _redirect,
    );
  }

  Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    final location = state.uri.toString();
    final mappedDeepLink = _mapDeepLink(state.uri);
    if (mappedDeepLink != null) return mappedDeepLink;

    if (_alwaysAllowed(location)) return null;
    if (!_supabaseInitialized()) return AppRoute.noConnection;

    final isAuthenticated = _isAuthenticated;
    if (!isAuthenticated && _isProtected(location)) {
      await _intentStore.save(location);
      return AppRoute.welcome;
    }

    if (isAuthenticated &&
        (location == AppRoute.welcome || location == AppRoute.login)) {
      final pending = await _intentStore.read();
      if (pending != null) {
        await _intentStore.clear();
        return _mapDeepLink(Uri.parse(pending.uri)) ?? pending.uri;
      }
      return AppRoute.home;
    }

    return null;
  }

  List<GoRoute> _detailRoutes() {
    return [
      _route(AppRoute.groupMembers),
      _route(AppRoute.groupSettings),
      _route(AppRoute.groupRides),
      _route(AppRoute.rideDetail),
      _route(AppRoute.groupDetail),
      _route(AppRoute.liveMap),
      _route(AppRoute.rideReplay),
      _route(AppRoute.addMaintenance),
      _route(AppRoute.maintenanceHistory),
      _route(AppRoute.maintenanceCalendar),
      _route(AppRoute.maintenanceDetail),
      _route(AppRoute.fuel),
      _route(AppRoute.addFuel),
      _route(AppRoute.notifications),
      _route(AppRoute.editProfile),
      _route(AppRoute.emergencyProfile),
      _route(AppRoute.settings),
      _route(AppRoute.addMotorcycle),
      _route(AppRoute.motorcyclePhotos),
      _route(AppRoute.editMotorcycle),
      _route(AppRoute.motorcycleDetail),
      _route(AppRoute.motorcycles),
      _route(AppRoute.aiReport),
      _route(AppRoute.aiHistory),
      _route(AppRoute.aiWeekly),
      _route(AppRoute.geofences),
      _route(AppRoute.search),
    ];
  }

  GoRoute _route(String path) {
    return GoRoute(
      path: path,
      name: path,
      builder: (_, _) => const SizedBox.shrink(),
    );
  }

  bool get _isAuthenticated {
    try {
      return _supabaseService.client.auth.currentSession != null;
    } on Object {
      return false;
    }
  }

  bool _alwaysAllowed(String location) {
    return location == AppRoute.noConnection || location == AppRoute.splash;
  }

  bool _isProtected(String location) {
    const publicRoutes = {
      AppRoute.splash,
      AppRoute.noConnection,
      AppRoute.onboarding,
      AppRoute.welcome,
      AppRoute.signUp,
      AppRoute.verifyEmail,
      AppRoute.login,
      AppRoute.phoneOtp,
      AppRoute.forgotPassword,
    };
    return !publicRoutes.contains(location) &&
        !location.startsWith('/groups/join/');
  }

  String? _mapDeepLink(Uri uri) {
    if (uri.scheme != 'motoorbito') return null;
    if (uri.host == 'join' && uri.pathSegments.isNotEmpty) {
      return '/groups/join/${uri.pathSegments.first}';
    }
    return null;
  }
}
