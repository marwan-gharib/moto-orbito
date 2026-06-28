# Navigation Contracts: Core Infrastructure (Phase 0)

**File**: `lib/core/router/routes.dart` + `lib/core/router/app_router.dart`

---

## Route Name Constants (complete list)

All values are path strings used as GoRouter `name` parameters.

```dart
abstract class AppRoute {
  // Shell / Auth
  static const splash               = '/splash';
  static const noConnection         = '/no-connection';
  static const onboarding           = '/onboarding';
  static const welcome              = '/welcome';
  static const signUp               = '/sign-up';
  static const verifyEmail          = '/verify-email';
  static const login                = '/login';
  static const phoneOtp             = '/phone-otp';
  static const forgotPassword       = '/forgot-password';
  static const profileSetup         = '/profile-setup';

  // Dashboard (root of bottom nav)
  static const home                 = '/home';

  // Groups
  static const groups               = '/groups';
  static const groupDetail          = '/groups/:groupId';
  static const groupMembers         = '/groups/:groupId/members';
  static const groupSettings        = '/groups/:groupId/settings';
  static const groupRides           = '/groups/:groupId/rides';
  static const rideDetail           = '/groups/:groupId/rides/:rideId';
  static const joinGroup            = '/groups/join/:inviteCode';

  // Tracking
  static const liveMap              = '/live-map/:rideId';
  static const rideReplay           = '/ride-replay/:rideId';

  // Maintenance
  static const maintenance          = '/maintenance';
  static const addMaintenance       = '/maintenance/add';
  static const maintenanceDetail    = '/maintenance/:logId';
  static const maintenanceHistory   = '/maintenance/history';
  static const maintenanceCalendar  = '/maintenance/calendar';

  // Fuel
  static const fuel                 = '/fuel';
  static const addFuel              = '/fuel/add';

  // Notifications
  static const notifications        = '/notifications';

  // Profile
  static const profile              = '/profile';
  static const editProfile          = '/profile/edit';
  static const emergencyProfile     = '/profile/emergency';
  static const settings             = '/settings';

  // Motorcycles
  static const motorcycles          = '/motorcycles';
  static const addMotorcycle        = '/motorcycles/add';
  static const motorcycleDetail     = '/motorcycles/:motoId';
  static const editMotorcycle       = '/motorcycles/:motoId/edit';
  static const motorcyclePhotos     = '/motorcycles/:motoId/photos';

  // AI
  static const aiReport             = '/ai/report/:rideId';
  static const aiHistory            = '/ai/history';
  static const aiWeekly             = '/ai/weekly';

  // Geofences / Search
  static const geofences            = '/geofences';
  static const search               = '/search';
}
```

---

## Auth Guard Contract

```
GoRouter.redirect logic:
  IF current route is in [noConnection, splash]      → allow always
  IF supabaseInitialized == false                    → redirect to /no-connection
  IF user is NOT authenticated AND route is protected → store pending URI → redirect to /welcome
  IF user IS authenticated AND route is /welcome or /login → redirect to /home
  ELSE                                               → allow
```

**Protected routes**: all routes EXCEPT `[splash, noConnection, onboarding, welcome, signUp, verifyEmail, login, phoneOtp, forgotPassword, joinGroup]`.

---

## Deep Link Scheme

**Scheme**: `motoorbito://`

| Deep Link URI | Mapped Route | Notes |
|--------------|-------------|-------|
| `motoorbito://join/{code}` | `/groups/join/:inviteCode` | Invite code from `groups.invite_code` |

**Unauthenticated handling**: Pending URI stored in `flutter_secure_storage` key `pending_deep_link`. Processed after login.
