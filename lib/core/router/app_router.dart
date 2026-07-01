import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubits/auth_cubit/auth_state.dart';
import '../../features/auth/presentation/cubits/forgot_password_cubit/forgot_password_cubit.dart';
import '../../features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import '../../features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import '../../features/auth/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import '../../features/auth/presentation/screens/email_verification_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/phone_otp_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../widgets/no_internet_screen.dart';
import 'deep_link_intent.dart';
import 'routes.dart';

final class _AuthListenable extends ChangeNotifier {
  _AuthListenable(AuthCubit cubit) {
    _sub = cubit.stream.listen((_) => notifyListeners());
  }

  StreamSubscription? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final class AppRouter {
  AppRouter(this._authCubit, this._intentStore, this._supabaseInitialized)
    : _authListenable = _AuthListenable(_authCubit);

  final AuthCubit _authCubit;
  final DeepLinkIntentStore _intentStore;
  final bool Function() _supabaseInitialized;
  final _AuthListenable _authListenable;

  GoRouter router() {
    return GoRouter(
      initialLocation: AppRoute.onboarding,
      refreshListenable: _authListenable,
      routes: [
        GoRoute(
          path: AppRoute.noConnection,
          name: AppRoute.noConnection,
          builder: (_, _) => const NoInternetScreen(),
        ),
        GoRoute(
          path: AppRoute.onboarding,
          name: AppRoute.onboarding,
          builder: (context, _) => BlocProvider.value(
            value: GetIt.instance<OnboardingCubit>(),
            child: OnboardingScreen(
              onOnboardingComplete: () => context.go(AppRoute.welcome),
            ),
          ),
        ),
        GoRoute(
          path: AppRoute.welcome,
          name: AppRoute.welcome,
          builder: (_, _) => const WelcomeScreen(),
        ),
        GoRoute(
          path: AppRoute.signUp,
          name: AppRoute.signUp,
          builder: (_, _) => BlocProvider.value(
            value: GetIt.instance<SignUpCubit>(),
            child: const SignUpScreen(),
          ),
        ),
        GoRoute(
          path: AppRoute.verifyEmail,
          name: AppRoute.verifyEmail,
          builder: (_, state) => BlocProvider.value(
            value: GetIt.instance<OtpCubit>(),
            child: EmailVerificationScreen(email: state.extra as String? ?? ''),
          ),
        ),
        GoRoute(
          path: AppRoute.login,
          name: AppRoute.login,
          builder: (_, _) => BlocProvider.value(
            value: GetIt.instance<LoginCubit>(),
            child: const LoginScreen(),
          ),
        ),
        GoRoute(
          path: AppRoute.phoneOtp,
          name: AppRoute.phoneOtp,
          builder: (_, state) => BlocProvider.value(
            value: GetIt.instance<OtpCubit>(),
            child: PhoneOtpScreen(phone: state.extra as String? ?? ''),
          ),
        ),
        GoRoute(
          path: AppRoute.forgotPassword,
          name: AppRoute.forgotPassword,
          builder: (_, _) => BlocProvider.value(
            value: GetIt.instance<ForgotPasswordCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        ),
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

    final isAuthenticated = _authCubit.state is AuthAuthenticated;
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
