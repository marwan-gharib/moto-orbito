# PLAN.md — Moto Orbito
## Master Engineering Plan — Phase 1 through Phase 3

> **This document is the execution blueprint for the entire Moto Orbito project.**
> Read `AGENT.md` and `GEMINI.md` before touching any phase in this plan.
> Every phase must be completed and verified before the next one begins.
> No phase is "done" until its Definition of Done checklist is fully checked.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Execution Phases Summary](#execution-phases-summary)
- [PHASE 0 — Project Foundation & Core Infrastructure](#phase-0--project-foundation--core-infrastructure)
- [PHASE 1 — Onboarding & Authentication](#phase-1--onboarding--authentication)
- [PHASE 2 — User Profile & Motorcycle Profile](#phase-2--user-profile--motorcycle-profile)
- [PHASE 3 — Group Rides (Groups Management)](#phase-3--group-rides-groups-management)
- [PHASE 4 — Group Rides (Ride Sessions)](#phase-4--group-rides-ride-sessions)
- [PHASE 5 — Live GPS Tracking](#phase-5--live-gps-tracking)
- [PHASE 6 — AI Riding Analysis](#phase-6--ai-riding-analysis)
- [PHASE 7 — Maintenance Tracking](#phase-7--maintenance-tracking)
- [PHASE 8 — Notifications System](#phase-8--notifications-system)
- [PHASE 9 — Dashboard & Statistics](#phase-9--dashboard--statistics)
- [PHASE 10 — Polish, QA & Release Prep](#phase-10--polish-qa--release-prep)
- [PHASE 11 — SOS & Emergency (Post-Job)](#phase-11--sos--emergency-post-job)
- [PHASE 12 — Social Feed (Post-Job)](#phase-12--social-feed-post-job)
- [PHASE 13 — Group Chat (Startup Vision)](#phase-13--group-chat-startup-vision)
- [PHASE 14 — Crash Detection (Startup Vision)](#phase-14--crash-detection-startup-vision)
- [Supabase Database Schema](#supabase-database-schema)
- [Edge Functions Map](#edge-functions-map)

---

## Project Overview

| Field              | Value                                                  |
|--------------------|--------------------------------------------------------|
| App Name           | Moto Orbito                                            |
| Tagline            | Ride Together, Stay in Orbit                           |
| Platform           | Flutter (iOS & Android)                                |
| Backend            | Supabase (Auth + DB + Realtime + Storage)              |
| Push Notifications | Firebase Cloud Messaging (FCM)                         |
| AI Services        | External AI API via Supabase Edge Function proxy       |
| Total Phases       | 14 (10 for Phase 1 product + 4 for Phase 2/3 roadmap) |
| Total Screens      | 70 screens across 14 modules                           |

---

## Execution Phases Summary

| Phase | Name                          | Scope                        | Screens | Priority    |
|-------|-------------------------------|------------------------------|---------|-------------|
| 0     | Foundation & Infrastructure   | Core setup, no features      | 0       | 🔴 Critical |
| 1     | Onboarding & Authentication   | Modules 01 + 02              | 11      | 🔴 Critical |
| 2     | User Profile & Motorcycle     | Modules 03 + 04              | 10      | 🔴 Critical |
| 3     | Group Management              | Module 05 (Groups part)      | 6       | 🔴 Critical |
| 4     | Ride Sessions                 | Module 05 (Rides part)       | 4       | 🔴 Critical |
| 5     | Live GPS Tracking             | Module 06                    | 4       | 🔴 Critical |
| 6     | AI Riding Analysis            | Module 07                    | 5       | 🟠 High     |
| 7     | Maintenance Tracking          | Module 08                    | 6       | 🟠 High     |
| 8     | Notifications System          | Module 09                    | 2       | 🟠 High     |
| 9     | Dashboard & Statistics        | Module 10                    | 8       | 🟠 High     |
| 10    | Polish, QA & Release Prep     | Shared + cross-cutting       | 6       | 🟠 High     |
| 11    | SOS & Emergency               | Module 11 (Phase 2)          | 2       | 🟡 Medium   |
| 12    | Social Feed                   | Module 12 (Phase 2)          | 3       | 🟡 Medium   |
| 13    | Group Chat                    | Module 13 (Phase 3)          | 2       | 🟢 Low      |
| 14    | Crash Detection               | Module 14 (Phase 3)          | 1       | 🟢 Low      |

> **Rule:** Phases 0–10 must be 100% complete before starting Phase 11.
> Phases 11–14 are gated behind product milestones, not just code completion.

---

---

# PHASE 0 — Project Foundation & Core Infrastructure

> **Goal:** A runnable Flutter project with zero features but 100% of the
> infrastructure in place. Every subsequent phase builds on this foundation.
> If this phase is wrong, everything built on top of it is wrong.

---

## 0.1 Flutter Project Bootstrap

> **The Flutter project and Android flavors already exist. Do not recreate them.**
> The project has two entry points: `lib/main_development.dart` and `lib/main_production.dart`.
> Each entry point maps to its own flavor and Supabase project (see AGENT.md Section 20).

**Tasks:**
- [ ] Configure `pubspec.yaml` with all pre-approved packages (see AGENT.md Section 18)
- [ ] Set up project root folder structure exactly as defined in AGENT.md Section 4

### Flavor Usage Rules

- [ ] Confirm `AppLogger` is a no-op in production — logging must only be active in the `development` flavor
- [ ] Confirm both entry points (`main_development.dart`, `main_production.dart`) initialize Supabase with their respective project credentials before `runApp()`
- [ ] Confirm both flavors can be installed side-by-side on the same Android device

**Acceptance Criteria:**
- Running via `--flavor development --target lib/main_development.dart` connects to `moto-orbito-dev` Supabase project with logging active
- Running via `--flavor production --target lib/main_production.dart` connects to `moto-orbito` Supabase project with logging silent
- `flutter analyze` returns zero issues
- Folder structure matches AGENT.md Section 4 exactly

---

## 0.2 Core — Error Handling

**Files to create:**
```
lib/core/error/
├── failures.dart          # All Failure subclasses
└── api_result.dart        # ApiResult<T> sealed class
```

**Specification:**

`ApiResult<T>` must be a sealed class with two subtypes:
- `Success<T>` — wraps the successful value
- `Failure<T>` — wraps a `Failure` object

`Failure` subclasses to define:
- `NetworkFailure` — no internet, timeout
- `ServerFailure` — non-2xx HTTP responses
- `AuthFailure` — unauthenticated, token expired
- `NotFoundFailure` — resource does not exist
- `PermissionFailure` — user lacks role/permission
- `StorageFailure` — file upload/download errors
- `UnexpectedFailure` — catch-all for unknown exceptions

**Rules:**
- Every `Failure` must carry a `message` field (localization key, not raw string)
- No raw exceptions must ever leave the data layer

**Acceptance Criteria:**
- `ApiResult<T>` compiles and can be pattern-matched with exhaustive `switch`
- All `Failure` subclasses defined
- Unit tests: success and failure path for `ApiResult`

---

## 0.3 Core — Dependency Injection (GetIt)

**Files to create:**
```
lib/core/di/
├── injection_container.dart    # Master setup() function
├── core_module.dart            # Core services registration
└── features/
    ├── auth_module.dart
    ├── profile_module.dart
    ├── motorcycle_module.dart
    ├── group_rides_module.dart
    ├── live_tracking_module.dart
    ├── ai_analysis_module.dart
    ├── maintenance_module.dart
    ├── notifications_module.dart
    └── dashboard_module.dart
```

**Rules:**
- `injection_container.dart` calls `setup()` which calls all module registrations in order
- Cubits → `registerFactory`
- UseCases → `registerLazySingleton`
- Repositories → `registerLazySingleton` (abstract bound to concrete)
- Services → `registerLazySingleton`

**Acceptance Criteria:**
- `GetIt.instance.setup()` runs in `main.dart` without errors
- Each module file is a standalone function, not a class

---

## 0.4 Core — Navigation (GoRouter)

**Files to create:**
```
lib/core/router/
├── routes.dart          # All route name constants
└── app_router.dart      # GoRouter instance with all routes defined
```

**Specification:**

Define ALL route name constants as `static const String` in `routes.dart`.
Full route list defined in AGENT.md Section 13.

`app_router.dart` rules:
- Use `ShellRoute` for bottom navigation (Dashboard, Groups, Live Map, Maintenance, Profile)
- Guard all authenticated routes with a `redirect` that checks auth state
- Redirect unauthenticated users to `/welcome`
- Redirect authenticated users away from `/welcome`, `/login`, `/sign-up`
- Deep link support: `motoorbito://join/{invite_code}`

**Acceptance Criteria:**
- All routes declared as named constants
- `GoRouter` instance is a singleton via GetIt
- Auth guard redirect works
- Deep link scheme registered in `AndroidManifest.xml` and `Info.plist`

---

## 0.5 Core — Networking (Dio + BaseApiClient)

**Files to create:**
```
lib/core/network/
├── base_api_client.dart
├── interceptors/
│   ├── auth_interceptor.dart       # Attaches Bearer token
│   ├── logging_interceptor.dart    # Uses AppLogger
│   └── error_mapping_interceptor.dart  # Maps HTTP errors to Failure
└── network_info.dart               # connectivity_plus wrapper
```

**Specification:**

`BaseApiClient` must expose:
- `get(path, {queryParams})` → `ApiResult<Map>`
- `post(path, {body})` → `ApiResult<Map>`
- `put(path, {body})` → `ApiResult<Map>`
- `delete(path)` → `ApiResult<void>`

`AuthInterceptor`:
- Reads JWT from `flutter_secure_storage`
- Attaches as `Authorization: Bearer {token}`
- On 401 response: attempts token refresh once, then emits `AuthFailure`

`NetworkInfo`:
- `isConnected` → `Future<bool>`
- Must be checked before every API call; return `NetworkFailure` if offline

**Acceptance Criteria:**
- `BaseApiClient` wraps all Dio calls — no raw Dio usage allowed outside this file
- Interceptors registered in correct order: Auth → Logging → Error Mapping
- `flutter analyze` passes

---

## 0.6 Core — Supabase Service

**Files to create:**
```
lib/core/services/supabase/
├── supabase_service.dart       # Thin wrapper around SupabaseClient
├── realtime_service.dart       # Channel management for live tracking
└── storage_service.dart        # File upload/download helpers
```

**Specification:**

`SupabaseService`:
- Exposes `SupabaseClient` instance
- Initialized once in `main.dart` before `runApp()`

`RealtimeService`:
- `subscribeToRide(rideId)` → subscribes to location channel
- `broadcastLocation(rideId, payload)` → sends location update
- `unsubscribeFromRide(rideId)` → removes channel subscription
- `dispose()` → removes all active subscriptions

`StorageService`:
- `uploadFile(bucket, path, file)` → `ApiResult<String>` (returns public URL)
- `deleteFile(bucket, path)` → `ApiResult<void>`
- Enforces 5MB file size limit before upload attempt

**Acceptance Criteria:**
- Supabase initializes successfully in `main.dart`
- `RealtimeService` can subscribe and broadcast on a test channel
- `StorageService` uploads and returns a valid URL

---

## 0.7 Core — Firebase FCM Service

**Files to create:**
```
lib/core/services/fcm/
├── fcm_service.dart        # Token management + notification handling
└── notification_handler.dart  # Navigation logic on notification tap
```

**Specification:**

`FcmService`:
- `initialize()` → requests permission, sets up foreground/background handlers
- `getToken()` → `Future<String?>` — returns device FCM token
- `onTokenRefresh` → stream that triggers FCM token update to Supabase
- Foreground notifications: displayed via `flutter_local_notifications`

`NotificationHandler`:
- Parses notification `type` and `target_id` from payload
- Routes to correct screen using GoRouter named routes
- Must handle all notification types defined in AGENT.md Section 6

**Acceptance Criteria:**
- FCM permission request works on both iOS and Android
- Foreground notification appears when app is open
- Tapping notification navigates to correct screen

---

## 0.8 Core — AI Service

**Files to create:**
```
lib/core/services/ai/
├── ai_service.dart         # HTTP client for Supabase Edge Function proxy
├── ai_prompts.dart         # All prompt templates as constants
└── ai_models.dart          # Input/output data models for AI calls
```

**Specification:**

`AiService`:
- All calls go to Supabase Edge Function URL (never directly to OpenAI/Gemini)
- `generateRideReport(input)` → `ApiResult<RideReportAiResponse>`
- `generateMaintenancePrediction(input)` → `ApiResult<MaintenancePredictionAiResponse>`
- Retry logic: max 2 retries on failure, 30-second timeout
- Uses `BaseApiClient` internally

`AiPrompts`:
- `rideReportPrompt({language, rideData})` → `String`
- `maintenancePredictionPrompt({language, motorcycleData})` → `String`
- `weeklyReportPrompt({language, weekData})` → `String`
- Language must always be injected (`ar` or `en`)

**Acceptance Criteria:**
- AI service compiles and connects to Edge Function endpoint
- Retry logic tested: fails gracefully on 3rd failure
- All prompts are constants — no inline prompt strings in service methods

---

## 0.9 Core — Theme System

**Files to create:**
```
lib/core/theme/
├── app_theme.dart                  # Light and Dark ThemeData instances
├── app_colors_extension.dart       # ThemeExtension with all brand colors
├── app_text_styles_extension.dart  # ThemeExtension for text styles (optional override)
└── spacing.dart                    # Spacing constants (4, 8, 12, 16, 24, 32, 48)
```

**Specification:**

`AppColorsExtension` must include:
- `primary` — brand orange/red (motorcycle brand feel)
- `primaryVariant`
- `surface`, `surfaceVariant`
- `onSurface`, `onPrimary`
- `error`, `success`, `warning`
- `mapBackground` — for live map overlay elements
- `scoreExcellent`, `scoreGood`, `scoreFair`, `scoreNeedsImprovement`
- `statusOk`, `statusDueSoon`, `statusOverdue`

`Spacing` class — static const values:
- `xs = 4.0`, `sm = 8.0`, `md = 12.0`, `lg = 16.0`, `xl = 24.0`, `xxl = 32.0`, `xxxl = 48.0`

**Rules:**
- Both light and dark themes must be complete from day one
- No `AppColors.primary` usage anywhere — only `Theme.of(context).extension<AppColorsExtension>()!.primary`
- Wrap access in a `BuildContext` extension for ergonomics: `context.colors.primary`

**Acceptance Criteria:**
- Light and dark theme switch works at runtime
- `context.colors` extension resolves correctly
- Zero hardcoded color values in any widget file

---

## 0.10 Core — Shared Widgets

**Files to create:**
```
lib/core/widgets/
├── app_button.dart             # Primary, secondary, danger variants
├── app_text_field.dart         # Styled input with validation support
├── app_loader.dart             # Circular loading indicator
├── app_snack_bar.dart          # Success, error, warning snack bars
├── app_skeleton.dart           # Shimmer placeholder
├── empty_state_widget.dart     # Reusable empty list state
├── error_widget.dart           # Error state with retry button
├── no_internet_widget.dart     # Offline state
└── bottom_nav_bar.dart         # Persistent bottom navigation (5 tabs)
```

**Specification:**

`AppButton`:
- Variants: `primary`, `secondary`, `danger`, `ghost`
- Props: `label`, `onTap`, `isLoading`, `isDisabled`, `icon`
- Uses `ThemeExtension` colors — no hardcoded colors

`AppTextField`:
- Props: `label`, `hint`, `controller`, `validator`, `obscureText`, `prefix`, `suffix`, `keyboardType`
- Shows validation error inline
- RTL-aware (works for Arabic text direction)

`EmptyStateWidget`:
- Props: `title`, `subtitle`, `ctaLabel`, `onCtaTap`, `illustration`
- Fully localized — no hardcoded strings

`BottomNavBar`:
- 5 tabs: Dashboard / Groups / Live Map / Maintenance / Profile
- Active tab uses brand primary color
- Uses GoRouter's `StatefulShellRoute` for independent navigation stacks

**Acceptance Criteria:**
- All widgets render in both light and dark mode
- All widgets support RTL layout
- Widget tests written for `AppButton`, `AppTextField`, `EmptyStateWidget`

---

## 0.11 Core — Localization Setup (slang)

**Files to create:**
```
assets/
└── i18n/
    ├── ar.json    # Arabic strings (primary)
    └── en.json    # English strings

lib/core/
└── i18n/         # Generated slang output (do not edit manually)
```

**Initial string keys to add at project start:**

```json
{
  "common": {
    "loading": "...",
    "retry": "...",
    "error": "...",
    "noInternet": "...",
    "save": "...",
    "cancel": "...",
    "delete": "...",
    "edit": "...",
    "confirm": "...",
    "back": "..."
  },
  "errors": {
    "network": "...",
    "server": "...",
    "auth": "...",
    "notFound": "...",
    "permission": "...",
    "unexpected": "..."
  }
}
```

**Rules:**
- `ar.json` is the source of truth — `en.json` must have identical keys
- Run `dart run slang` after every key addition
- Locale determined by user profile setting, stored in `flutter_secure_storage`

**Acceptance Criteria:**
- App renders in Arabic by default
- Language switches to English when user preference changes
- `dart run slang` generates without errors

---

## 0.12 Core — AppLogger

**File:** `lib/core/utils/app_logger.dart`

**Specification:**
- Wraps a logging package (e.g., `logger`)
- `AppLogger.debug(message)`
- `AppLogger.info(message)`
- `AppLogger.warning(message)`
- `AppLogger.error(message, {error, stackTrace})`
- In release builds: disable debug/info logs, keep error logs
- NEVER log: passwords, tokens, emergency contacts, blood type, phone numbers

**Acceptance Criteria:**
- `print()` usage causes `flutter analyze` lint warning (add custom lint rule or convention)
- Sensitive data logging tested to confirm it does not appear

---

## Phase 0 — Definition of Done

- [ ] `flutter run` succeeds — blank app with bottom nav structure visible
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all core unit tests pass
- [ ] GetIt setup works — all modules register without errors
- [ ] GoRouter — all routes declared, auth guard works
- [ ] Supabase — initializes and can query a test table
- [ ] Firebase — FCM token retrieved successfully
- [ ] Theme — light and dark mode work, `context.colors` resolves
- [ ] Localization — Arabic and English switch works
- [ ] All shared widgets render correctly in both themes and both directions (LTR/RTL)
- [ ] No hardcoded strings, colors, or sizes anywhere in `core/`

---

---

# PHASE 1 — Onboarding & Authentication

> **Goal:** A new user can open the app for the first time, see the onboarding slides,
> create an account (email+phone+password or Google or Facebook), verify their email,
> and reach the main app. An existing user can log in and stay logged in across sessions.

> **Prerequisite:** Phase 0 complete.

---

## 1.1 Feature: Onboarding (Module 01)

**Screens:** Splash, Slide 1, Slide 2, Slide 3

**Folder:** `lib/features/onboarding/`

### Domain Layer

No external data needed. Onboarding state is purely local.

**UseCase:** `CheckOnboardingCompleteUseCase`
- Reads from local storage (`flutter_secure_storage`) whether onboarding was seen
- Returns `bool`

**UseCase:** `MarkOnboardingCompleteUseCase`
- Writes `onboarding_seen = true` to local storage

### Presentation Layer

**Cubit:** `OnboardingCubit`

States (sealed class):
```dart
sealed class OnboardingState {}
class OnboardingInitial extends OnboardingState {}
class OnboardingInProgress extends OnboardingState { final int currentPage; }
class OnboardingComplete extends OnboardingState {}
```

Methods:
- `checkIfSeen()` → navigates to `/welcome` if seen, else shows slides
- `nextPage()` → increments `currentPage`
- `skip()` → emits `OnboardingComplete` → navigates to `/welcome`
- `getStarted()` → marks complete → navigates to `/sign-up`

**Screens:**

`SplashScreen`:
- Displays animated app logo (Lottie or custom `AnimatedWidget`)
- After 2.5 seconds: calls `checkIfSeen()`
- No user interaction

`OnboardingScreen`:
- `PageView` with 3 slides, dots indicator, Next/Skip buttons
- Slide 1: Ride Together — group rides illustration
- Slide 2: Ride Smarter — AI insights illustration
- Slide 3: Ride Safe — maintenance + safety illustration
- Last slide: "Get Started" replaces "Next"

**Acceptance Criteria:**
- [ ] Splash shows for ~2.5 seconds then auto-navigates
- [ ] Skip goes directly to `/welcome` from any slide
- [ ] "Get Started" on slide 3 goes to `/sign-up`
- [ ] Onboarding is never shown again after first completion
- [ ] Works in both Arabic (RTL, slides right-to-left) and English

---

## 1.2 Feature: Authentication (Module 02)

**Screens:** Welcome, Sign Up, Email Verification, Login, Phone OTP (Enter + Verify), Forgot Password

**Folder:** `lib/features/auth/`

### Data Layer

**Models:**
- `AuthUserModel` — maps Supabase `auth.users` response
- `SignUpRequestModel` — email, phone, password, full name
- `LoginRequestModel` — email, password

**Repository Implementation:** `AuthRepositoryImpl`

Methods:
- `signUpWithEmailPassword(params)` → creates Supabase auth user + inserts `users` table row
- `signInWithEmailPassword(params)` → Supabase sign in
- `signInWithGoogle()` → Supabase OAuth Google
- `signInWithFacebook()` → Supabase OAuth Facebook
- `sendEmailOtp(email)` → Supabase OTP
- `verifyEmailOtp(email, token)` → verifies Supabase OTP
- `sendPhoneOtp(phone)` → Supabase phone OTP
- `verifyPhoneOtp(phone, token)` → verifies Supabase phone OTP
- `sendPasswordResetEmail(email)`
- `signOut()` → clears JWT from secure storage + clears FCM token in Supabase
- `deleteAccount()` → Supabase admin delete (via Edge Function) + cascade cleanup
- `getSession()` → returns current session or null
- `isEmailVerified()` → bool

**Mapper:** `AuthUserMapper` — maps `AuthUserModel` → `UserEntity`

### Domain Layer

**Entity:** `UserEntity` — id, email, phone, fullName, isEmailVerified, createdAt

**Repository Contract:** `AuthRepository` (abstract)

**UseCases:**
- `SignUpUseCase(params: SignUpParams)` → `ApiResult<UserEntity>`
- `SignInWithEmailUseCase(params: LoginParams)` → `ApiResult<UserEntity>`
- `SignInWithGoogleUseCase(params: NoParams)` → `ApiResult<UserEntity>`
- `SignInWithFacebookUseCase(params: NoParams)` → `ApiResult<UserEntity>`
- `SendEmailVerificationUseCase(params: EmailParams)`
- `VerifyEmailOtpUseCase(params: OtpVerifyParams)`
- `SendPhoneOtpUseCase(params: PhoneParams)`
- `VerifyPhoneOtpUseCase(params: OtpVerifyParams)`
- `SendPasswordResetUseCase(params: EmailParams)`
- `SignOutUseCase(params: NoParams)`
- `DeleteAccountUseCase(params: NoParams)`
- `GetSessionUseCase(params: NoParams)` → used by GoRouter redirect

### Presentation Layer

**Cubits:**

`AuthCubit` (global, survives navigation):
```dart
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthAuthenticated extends AuthState { final UserEntity user; }
class AuthUnauthenticated extends AuthState {}
class AuthLoading extends AuthState {}
class AuthError extends AuthState { final String messageKey; }
```

`SignUpCubit`:
```dart
sealed class SignUpState {}
class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}
class SignUpSuccess extends SignUpState {}
class SignUpError extends SignUpState { final String messageKey; }
```

`LoginCubit` — similar to SignUpCubit

`OtpCubit`:
```dart
sealed class OtpState {}
class OtpInitial extends OtpState {}
class OtpSending extends OtpState {}
class OtpSent extends OtpState { final int resendCountdownSeconds; }
class OtpVerifying extends OtpState {}
class OtpVerified extends OtpState {}
class OtpError extends OtpState { final String messageKey; }
class OtpResendAvailable extends OtpState {}
```

**Screens:**

`WelcomeScreen`:
- Login button → `/login`
- Sign Up button → `/sign-up`
- Google Sign-In button → triggers `SignInWithGoogleUseCase`

`SignUpScreen`:
- Fields: Full name, email, phone (with country code picker), password, confirm password
- Validate all fields before submission
- On success → navigate to `/verify-email`

`EmailVerificationScreen`:
- Shows "Check your email" message with the email address
- Resend button (disabled for 60 seconds after send)
- OTP input (6 digits) — on fill complete, auto-verify
- On verified → navigate to `/profile-setup`

`LoginScreen`:
- Fields: Email, Password
- Forgot Password link → `/forgot-password`
- Google Sign-In button
- Facebook Sign-In button
- On success → GoRouter redirect sends to `/home`

`PhoneOtpEnterScreen`:
- Country code picker + phone field
- "Send OTP" button
- On success → navigate to `PhoneOtpVerifyScreen`

`PhoneOtpVerifyScreen`:
- 6-digit OTP input fields (one per digit, auto-advance)
- Countdown timer (60 seconds) → Resend button appears after countdown
- On verified → navigate to appropriate next screen (context-aware)

`ForgotPasswordScreen`:
- Email field
- "Send Reset Link" button
- On success: show confirmation message (do not navigate away)

**Localization keys to add (auth namespace):**
```json
"auth": {
  "welcomeTitle": "...",
  "signUp": "...",
  "login": "...",
  "continueWithGoogle": "...",
  "continueWithFacebook": "...",
  "emailLabel": "...",
  "passwordLabel": "...",
  "confirmPasswordLabel": "...",
  "fullNameLabel": "...",
  "phoneLabel": "...",
  "forgotPassword": "...",
  "sendResetLink": "...",
  "checkEmailMessage": "...",
  "resendCode": "...",
  "verifyEmail": "...",
  "otpLabel": "...",
  "validation": {
    "emailRequired": "...",
    "emailInvalid": "...",
    "passwordRequired": "...",
    "passwordTooShort": "...",
    "passwordsDoNotMatch": "...",
    "nameRequired": "...",
    "phoneRequired": "..."
  }
}
```

**Acceptance Criteria:**
- [ ] Sign up with email + phone + password creates a Supabase user
- [ ] Email OTP verification flow works end-to-end
- [ ] Google Sign-In works on iOS and Android
- [ ] Facebook Sign-In works on iOS and Android
- [ ] Login with valid credentials → reaches `/home`
- [ ] Login with wrong password → shows error (not raw exception)
- [ ] Forgot password → confirmation message shown, email sent
- [ ] Auto-login on app restart if session exists
- [ ] Logout clears session and FCM token
- [ ] Account deletion removes user from Supabase auth and all tables
- [ ] OTP countdown timer works; resend only enabled after 60 seconds
- [ ] All validation messages shown inline, not as snack bars
- [ ] All screens tested in Arabic RTL and English LTR

**Unit Tests:**
- [ ] `SignUpUseCase` — success, email already exists, invalid phone
- [ ] `SignInWithEmailUseCase` — success, wrong password, user not found
- [ ] `VerifyEmailOtpUseCase` — success, wrong code, expired code
- [ ] `SignOutUseCase` — clears session
- [ ] `AuthCubit` — all state transitions

---

## Phase 1 — Definition of Done

- [ ] User can complete full sign up flow (email path)
- [ ] User can sign in with Google and Facebook
- [ ] Email OTP verification works
- [ ] Auto-login on app restart
- [ ] Logout and account deletion work
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 1 tests pass
- [ ] Both themes (light/dark) render correctly on all screens
- [ ] Both languages (Arabic RTL / English) render correctly

---

---

# PHASE 2 — User Profile & Motorcycle Profile

> **Goal:** After signing up, a new user completes their profile setup.
> Returning users can view and edit their profile, manage emergency info,
> add and manage motorcycles, and set one as their primary motorcycle.

> **Prerequisite:** Phase 1 complete. User is authenticated and session exists.

---

## 2.1 Feature: User Profile (Module 03)

**Screens:** Profile Setup (post sign-up), My Profile, Edit Profile, Emergency Info, App Settings

**Folder:** `lib/features/profile/`

### Data Layer

**Supabase Table:** `users`
```
id               UUID (FK to auth.users)
full_name        TEXT
username         TEXT UNIQUE
profile_photo    TEXT (Supabase Storage URL)
phone            TEXT
riding_experience ENUM (beginner, intermediate, expert)
riding_style     ENUM (city, highway, off_road, mixed)
language         ENUM (ar, en)
dark_mode        BOOLEAN
fcm_token        TEXT
speed_limit_kmh  INTEGER (for speed alerts, default 120)
emergency_contact_name  TEXT
emergency_contact_phone TEXT
blood_type       ENUM (A+, A-, B+, B-, AB+, AB-, O+, O-)
medical_notes    TEXT
created_at       TIMESTAMPTZ
updated_at       TIMESTAMPTZ
```

**Models:** `UserProfileModel`, `EmergencyInfoModel`

**Repository Implementation:** `ProfileRepositoryImpl`
- `getProfile(userId)` → `ApiResult<UserProfileEntity>`
- `updateProfile(params)` → `ApiResult<UserProfileEntity>`
- `updateEmergencyInfo(params)` → `ApiResult<void>`
- `uploadProfilePhoto(file)` → `ApiResult<String>` (uses StorageService)
- `updateLanguage(language)` → `ApiResult<void>`
- `updateDarkMode(isDark)` → `ApiResult<void>`

**Mapper:** `UserProfileMapper`

### Domain Layer

**Entity:** `UserProfileEntity` — all fields from the `users` table (excluding sensitive: emergency info is a separate entity `EmergencyInfoEntity`)

**UseCases:**
- `GetProfileUseCase`
- `UpdateProfileUseCase`
- `UpdateEmergencyInfoUseCase`
- `UploadProfilePhotoUseCase`
- `UpdateLanguagePreferenceUseCase`
- `UpdateDarkModeUseCase`

### Presentation Layer

**Cubits:**

`ProfileCubit`:
```dart
sealed class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileLoaded extends ProfileState { final UserProfileEntity profile; }
class ProfileUpdating extends ProfileState { final UserProfileEntity current; }
class ProfileUpdated extends ProfileState { final UserProfileEntity profile; }
class ProfileError extends ProfileState { final String messageKey; }
```

`EmergencyInfoCubit` — separate cubit for emergency info (sensitive data, isolated)

**Screens:**

`ProfileSetupScreen` (first time only, after email verification):
- Fields: Username, profile photo (optional), riding experience level, riding style
- "Save & Continue" → navigates to `/home`
- Cannot be skipped — required to use the app

`MyProfileScreen`:
- Displays all profile fields
- Stats summary (total rides, total distance, avg score)
- "Edit Profile" button → `/profile/edit`
- "My Motorcycles" shortcut → `/motorcycles`
- "Emergency Info" → `/profile/emergency`

`EditProfileScreen`:
- Pre-filled form with current data
- Photo upload via `image_picker` → `StorageService`
- All fields editable except email (email change requires re-auth)
- "Save" → calls `UpdateProfileUseCase`

`EmergencyInfoScreen`:
- Emergency contact name + phone
- Blood type picker (dropdown)
- Medical notes (free text)
- Warning banner: "This information may be shared with emergency services"
- Saved separately from profile (extra confirmation dialog)

`AppSettingsScreen`:
- Language toggle (Arabic / English) → triggers `UpdateLanguagePreferenceUseCase` + app locale change
- Dark/Light mode toggle → triggers `UpdateDarkModeUseCase` + theme change
- Notification preferences shortcut → `/notifications/preferences`
- Account deletion (confirmation dialog with warning) → `DeleteAccountUseCase`
- Logout button

**Acceptance Criteria:**
- [ ] Profile setup is required after sign-up — cannot skip
- [ ] Photo upload works on iOS and Android
- [ ] Emergency info saved separately with extra confirmation
- [ ] Language change takes effect immediately without restart
- [ ] Dark/Light mode change takes effect immediately
- [ ] Account deletion shows confirmation dialog before proceeding
- [ ] Logout clears session and returns to `/welcome`

---

## 2.2 Feature: Motorcycle Profile (Module 04)

**Screens:** My Motorcycles, Add Motorcycle, Motorcycle Detail, Edit Motorcycle, Motorcycle Photos

**Folder:** `lib/features/motorcycle/`

### Data Layer

**Supabase Table:** `motorcycles`
```
id                UUID
user_id           UUID (FK users.id)
make              TEXT
model             TEXT
year              INTEGER
engine_cc         INTEGER
fuel_type         ENUM (petrol, diesel, electric)
plate_number      TEXT
mileage_km        INTEGER
nickname          TEXT
is_primary        BOOLEAN DEFAULT false
insurance_expiry  DATE
registration_expiry DATE
created_at        TIMESTAMPTZ
updated_at        TIMESTAMPTZ
```

**Supabase Table:** `motorcycle_photos`
```
id              UUID
motorcycle_id   UUID (FK motorcycles.id)
url             TEXT
order_index     INTEGER
created_at      TIMESTAMPTZ
```

**Repository Implementation:** `MotorcycleRepositoryImpl`
- `getMotorcycles(userId)` → `ApiResult<List<MotorcycleEntity>>`
- `addMotorcycle(params)` → `ApiResult<MotorcycleEntity>`
- `updateMotorcycle(params)` → `ApiResult<MotorcycleEntity>`
- `deleteMotorcycle(motorcycleId)` → `ApiResult<void>`
- `setPrimary(motorcycleId, userId)` → `ApiResult<void>` (transaction: unset all others first)
- `uploadPhoto(motorcycleId, file)` → `ApiResult<String>`
- `deletePhoto(photoId)` → `ApiResult<void>`
- `getPhotos(motorcycleId)` → `ApiResult<List<String>>`

### Domain Layer

**Entity:** `MotorcycleEntity`

**UseCases:**
- `GetMotorcyclesUseCase`
- `AddMotorcycleUseCase`
- `UpdateMotorcycleUseCase`
- `DeleteMotorcycleUseCase`
- `SetPrimaryMotorcycleUseCase`
- `UploadMotorcyclePhotoUseCase`
- `DeleteMotorcyclePhotoUseCase`
- `GetMotorcyclePhotosUseCase`

### Presentation Layer

**Cubits:**

`MotorcycleListCubit`:
```dart
sealed class MotorcycleListState {}
class MotorcycleListInitial extends MotorcycleListState {}
class MotorcycleListLoading extends MotorcycleListState {}
class MotorcycleListLoaded extends MotorcycleListState {
  final List<MotorcycleEntity> motorcycles;
  final String primaryId;
}
class MotorcycleListError extends MotorcycleListState { final String messageKey; }
```

`MotorcycleDetailCubit` — for single motorcycle view/edit

**Screens:**

`MyMotorcyclesScreen`:
- List of all user motorcycles
- Primary motorcycle card at the top (visually distinct)
- "Set as Primary" action on each card
- "Add New" FAB → `/motorcycles/add`
- Tap card → `/motorcycles/:motoId`

`AddMotorcycleScreen` / `EditMotorcycleScreen`:
- Fields: Make, Model, Year, Engine CC, Fuel Type, License Plate, Current Mileage (km), Nickname
- Insurance expiry date picker, Registration expiry date picker
- Photo picker (upload up to 5 photos)
- "Save" → calls appropriate UseCase

`MotorcycleDetailScreen`:
- All motorcycle info displayed
- Photo gallery (horizontal scroll)
- Maintenance status cards (loaded from maintenance feature data)
- Insurance expiry countdown — color coded: green (>30 days), orange (≤30), red (≤7)
- Registration expiry countdown — same logic
- "Edit" button → `/motorcycles/:motoId/edit`

`MotorcyclePhotosScreen`:
- Full gallery with add/remove
- Max 5 photos enforced — "Add Photo" disabled when limit reached

**Business Rules:**
- Only one motorcycle can be `is_primary = true` per user at any time
- `SetPrimaryMotorcycleUseCase` must use a Supabase transaction (or RPC) to atomically unset old primary and set new one
- Expiry date reminders (30/7/1 day) are scheduled via Supabase Edge Function cron — not from Flutter client
- Photo count must be validated in `UploadMotorcyclePhotoUseCase` before upload attempt

**Acceptance Criteria:**
- [ ] User can add multiple motorcycles
- [ ] Setting a new primary correctly updates `is_primary` on all motorcycles
- [ ] Insurance/registration expiry countdowns show correct colors
- [ ] Photo gallery enforces 5-photo limit
- [ ] All fields persist correctly to Supabase
- [ ] Motorcycle deletion removes associated photos from Storage

---

## Phase 2 — Definition of Done

- [ ] New user is forced through Profile Setup after sign-up
- [ ] Profile edit (including photo upload) works
- [ ] Emergency info saved with confirmation
- [ ] Language and dark mode toggle work immediately
- [ ] Motorcycle CRUD works end-to-end
- [ ] Primary motorcycle logic is atomic and correct
- [ ] Expiry countdowns display correctly
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 2 tests pass

---

---

# PHASE 3 — Group Rides (Groups Management)

> **Goal:** Users can create ride groups, join existing groups via invite code or link,
> manage group members and roles, and leave or delete groups.

> **Prerequisite:** Phase 2 complete.

---

## 3.1 Feature: Groups (Module 05 — Groups Part)

**Screens:** My Groups, Create Group, Group Detail, Group Members, Group Settings, Join Group

**Folder:** `lib/features/group_rides/` (shared with Phase 4)

### Data Layer

**Supabase Table:** `groups`
```
id              UUID
name            TEXT
description     TEXT
cover_photo     TEXT (Storage URL)
is_public       BOOLEAN DEFAULT true
invite_code     TEXT UNIQUE (6-digit alphanumeric, uppercase)
owner_id        UUID (FK users.id)
created_at      TIMESTAMPTZ
updated_at      TIMESTAMPTZ
```

**Supabase Table:** `group_members`
```
id          UUID
group_id    UUID (FK groups.id)
user_id     UUID (FK users.id)
role        ENUM (owner, admin, member)
joined_at   TIMESTAMPTZ
```

**Repository Implementation:** `GroupRepositoryImpl`
- `getMyGroups(userId)` → `ApiResult<List<GroupEntity>>`
- `createGroup(params)` → `ApiResult<GroupEntity>` (auto-inserts owner as member with role `owner`)
- `getGroupDetail(groupId)` → `ApiResult<GroupEntity>`
- `updateGroup(params)` → `ApiResult<GroupEntity>`
- `deleteGroup(groupId)` → `ApiResult<void>` (owner only — via RLS + Edge Function)
- `joinGroupByCode(code, userId)` → `ApiResult<GroupEntity>`
- `leaveGroup(groupId, userId)` → `ApiResult<void>` (owner cannot leave — must delete)
- `removeMember(groupId, targetUserId)` → `ApiResult<void>` (admin/owner only)
- `promoteMember(groupId, targetUserId, newRole)` → `ApiResult<void>` (owner only)
- `getMembers(groupId)` → `ApiResult<List<GroupMemberEntity>>`
- `uploadCoverPhoto(groupId, file)` → `ApiResult<String>`
- `regenerateInviteCode(groupId)` → `ApiResult<String>` (owner only)

**Mapper:** `GroupMapper`, `GroupMemberMapper`

### Domain Layer

**Entities:** `GroupEntity`, `GroupMemberEntity`

**Enums:** `UserRole { owner, admin, member }` — defined in `core/` and reused across features

**UseCases:**
- `GetMyGroupsUseCase`
- `CreateGroupUseCase`
- `GetGroupDetailUseCase`
- `UpdateGroupUseCase`
- `DeleteGroupUseCase`
- `JoinGroupByCodeUseCase`
- `LeaveGroupUseCase`
- `RemoveMemberUseCase`
- `PromoteMemberUseCase`
- `GetGroupMembersUseCase`
- `RegenerateInviteCodeUseCase`

**Role-check logic (domain layer only):**
- `canRemoveMember(actorRole)` → `actorRole == admin || actorRole == owner`
- `canManageGroup(actorRole)` → `actorRole == owner`
- `canPromoteMember(actorRole)` → `actorRole == owner`

### Presentation Layer

**Cubits:** `GroupListCubit`, `GroupDetailCubit`, `GroupMembersCubit`, `CreateGroupCubit`

**Screens:**

`MyGroupsScreen`:
- List of all groups user belongs to (with role badge)
- "Create Group" FAB
- Tap group → `/groups/:groupId`

`CreateGroupScreen`:
- Fields: Name, Description, Cover photo (optional), Public/Private toggle
- "Create" → calls `CreateGroupUseCase` → navigates to group detail

`GroupDetailScreen`:
- Group info (name, description, cover photo)
- Member count
- Upcoming rides preview (loaded from rides data — shows count only in Phase 3)
- Join/Leave button (hidden for owner)
- Share invite code button (copies link to clipboard or shows share sheet)
- Settings button (owner only) → `/groups/:groupId/settings`

`GroupMembersScreen`:
- List of all members with role badges
- Owner/Admin can tap member to see options: Remove / Promote to Admin
- Member count in app bar

`GroupSettingsScreen` (owner only):
- Edit name, description, cover photo
- Public/Private toggle
- Promote member to Admin (opens member picker)
- Regenerate invite code (with warning: old code becomes invalid)
- Delete group (confirmation dialog — irreversible)

`JoinGroupScreen`:
- 6-digit code input
- "Join" button
- Error if code not found or group is full (no cap — but handle DB errors)
- On success → navigate to group detail

**Business Rules:**
- Group owner cannot leave the group — must delete it instead (enforce in domain layer)
- Invite code is always 6 characters, uppercase alphanumeric
- Private group: only joinable via code. Public group: anyone can browse and join (implement discovery in Phase 9 Search)
- Invite link format: `motoorbito://join/{code}` — deep link handled by `NotificationHandler`
- Cover photo max 5MB, uploaded to `groups` bucket in Supabase Storage

**Acceptance Criteria:**
- [ ] Create group and auto-join as owner
- [ ] Join public group without code
- [ ] Join private group with 6-digit code
- [ ] Member list shows correct role badges
- [ ] Admin can remove members
- [ ] Owner can promote member to admin
- [ ] Owner can delete group with confirmation
- [ ] Invite link opens app and joins group (deep link)
- [ ] Regenerate code invalidates old code

---

## Phase 3 — Definition of Done

- [ ] Full group CRUD works
- [ ] Join by code and join by link work
- [ ] Role-based actions enforced in domain layer
- [ ] Owner cannot leave (UI hides button, domain layer rejects if called)
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 3 tests pass

---

---

# PHASE 4 — Group Rides (Ride Sessions)

> **Goal:** Group owners and admins can create ride sessions within a group.
> Members can view upcoming rides and join them. Owners/Admins can start and stop rides.
> Past rides are stored and accessible.

> **Prerequisite:** Phase 3 complete.

---

## 4.1 Feature: Ride Sessions (Module 05 — Rides Part)

**Screens:** Group Rides (tabs), Create Ride, Ride Detail (pre-start), Active Ride

**Folder:** `lib/features/group_rides/` (continued)

### Data Layer

**Supabase Table:** `rides`
```
id              UUID
group_id        UUID (FK groups.id)
name            TEXT
status          ENUM (upcoming, active, completed, cancelled)
scheduled_at    TIMESTAMPTZ
meeting_point   JSONB { lat, lng, address }
destination     JSONB { lat, lng, address } NULLABLE
created_by      UUID (FK users.id)
started_at      TIMESTAMPTZ NULLABLE
ended_at        TIMESTAMPTZ NULLABLE
created_at      TIMESTAMPTZ
updated_at      TIMESTAMPTZ
```

**Supabase Table:** `ride_participants`
```
id          UUID
ride_id     UUID (FK rides.id)
user_id     UUID (FK users.id)
joined_at   TIMESTAMPTZ
is_safe     BOOLEAN DEFAULT false
```

**Repository Implementation:** `RideRepositoryImpl`
- `getRides(groupId, status)` → `ApiResult<List<RideEntity>>`
- `createRide(params)` → `ApiResult<RideEntity>`
- `getRideDetail(rideId)` → `ApiResult<RideEntity>`
- `startRide(rideId)` → `ApiResult<void>` (sets status to `active`, records `started_at`)
- `stopRide(rideId)` → `ApiResult<void>` (sets status to `completed`, records `ended_at`)
- `cancelRide(rideId)` → `ApiResult<void>` (sets status to `cancelled`)
- `joinRide(rideId, userId)` → `ApiResult<void>`
- `leaveRide(rideId, userId)` → `ApiResult<void>`
- `getParticipants(rideId)` → `ApiResult<List<RideParticipantEntity>>`
- `broadcastSafe(rideId, userId)` → `ApiResult<void>` (sets `is_safe = true` for participant)
- `getAllRidesHistory(userId)` → `ApiResult<List<RideEntity>>` (across all groups)

### Domain Layer

**Entities:** `RideEntity`, `RideParticipantEntity`
**Enum:** `RideStatus { upcoming, active, completed, cancelled }`

**UseCases:**
- `GetGroupRidesUseCase`
- `CreateRideUseCase`
- `GetRideDetailUseCase`
- `StartRideUseCase`
- `StopRideUseCase`
- `CancelRideUseCase`
- `JoinRideUseCase`
- `LeaveRideUseCase`
- `GetRideParticipantsUseCase`
- `BroadcastSafeUseCase`
- `GetAllRidesHistoryUseCase`

### Presentation Layer

**Screens:**

`GroupRidesScreen`:
- 3 tabs: Upcoming | Active | Past
- Each tab shows a list of rides with status, date, participant count
- "Create Ride" button (owner/admin only — hide for members)
- Tap ride → `/groups/:groupId/rides/:rideId`

`CreateRideScreen`:
- Fields: Ride name, Date & time picker, Meeting point (Google Maps picker), Destination (optional)
- "Create" → calls `CreateRideUseCase` → navigates back to group rides

`RideDetailScreen` (before start):
- Ride info: name, date/time, meeting point on mini-map, destination
- Participant list (avatars + names)
- "Join Ride" button (for members who haven't joined)
- "Leave Ride" button (for joined members)
- "Start Ride" button (owner/admin only — only when `status == upcoming`)
- "Cancel Ride" button (owner/admin only)
- On "Start Ride" → sets status to `active` → navigates to `ActiveRideScreen`

`ActiveRideScreen`:
- Live map with all rider markers (from Phase 5 — stub this with participant list in Phase 4)
- "I'm Safe" button → calls `BroadcastSafeUseCase`
- Speed display (from GPS — stub in Phase 4)
- "Stop Ride" button (owner/admin only)
- Participant drawer (pull up from bottom)
- On "Stop Ride" → calls `StopRideUseCase` → triggers AI analysis (Phase 6) → navigate to Ride Report

**Acceptance Criteria:**
- [ ] Owner/Admin can create a ride with meeting point on map
- [ ] Members can join/leave upcoming rides
- [ ] Start Ride changes status to active
- [ ] Stop Ride changes status to completed
- [ ] Cancel Ride changes status to cancelled
- [ ] "I'm Safe" button updates participant state
- [ ] Rides list correctly shows all 3 tabs (upcoming, active, past)
- [ ] Past rides link to Ride Detail history screen

---

## Phase 4 — Definition of Done

- [ ] Full ride session lifecycle: create → start → active → stop → completed
- [ ] Join/leave ride works for members
- [ ] Role-based actions enforced (only owner/admin can start/stop)
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 4 tests pass

---

---

# PHASE 5 — Live GPS Tracking

> **Goal:** During an active ride, all participants see each other on a live map
> with real-time location updates. GPS tracks each rider's route. Speed alerts
> and geofence alerts are functional. After the ride, the full route is saved
> and can be replayed.

> **Prerequisite:** Phase 4 complete. Active ride session exists.

---

## 5.1 Feature: Live GPS Tracking (Module 06)

**Screens:** Live Map, Rider Info Popup (overlay), Ride Replay, Geofence Manager

**Folder:** `lib/features/live_tracking/`

### Data Layer

**Supabase Table:** `ride_locations`
```
id          UUID
ride_id     UUID (FK rides.id)
rider_id    UUID (FK users.id)
lat         DOUBLE PRECISION
lng         DOUBLE PRECISION
speed_kmh   REAL
heading     REAL (degrees, 0-360)
timestamp   TIMESTAMPTZ
```

**Supabase Table:** `geofences`
```
id              UUID
user_id         UUID (FK users.id)
name            TEXT
center_lat      DOUBLE PRECISION
center_lng      DOUBLE PRECISION
radius_meters   INTEGER
is_active       BOOLEAN DEFAULT true
created_at      TIMESTAMPTZ
```

**Repository Implementation:** `LiveTrackingRepositoryImpl`
- `startLocationBroadcast(rideId)` → starts GPS + Supabase Realtime broadcast every 3 seconds
- `stopLocationBroadcast(rideId)` → stops GPS + unsubscribes channel
- `subscribeToRideLocations(rideId, onUpdate)` → opens Realtime channel, fires callback on each update
- `saveRideRoute(rideId, riderId, points)` → batch inserts location points at ride end
- `getRideRoute(rideId, riderId)` → `ApiResult<List<LocationPointEntity>>`
- `getAllRiderRoutes(rideId)` → `ApiResult<Map<String, List<LocationPointEntity>>>`
- `getGeofences(userId)` → `ApiResult<List<GeofenceEntity>>`
- `addGeofence(params)` → `ApiResult<GeofenceEntity>`
- `deleteGeofence(geofenceId)` → `ApiResult<void>`
- `toggleGeofence(geofenceId, isActive)` → `ApiResult<void>`

**GPS Service:** `lib/core/services/gps/gps_service.dart`
- `requestPermission()` → `Future<bool>`
- `startTracking()` → `Stream<LocationPoint>`
- `stopTracking()` → void
- `getCurrentLocation()` → `Future<LocationPoint>`
- Uses `geolocator` with `LocationAccuracy.high`
- Converts `position.speed` (m/s) → km/h
- Foreground service on Android (`flutter_foreground_task` or platform channel)
- Background location mode on iOS (`UIBackgroundModes: location` in Info.plist)

### Domain Layer

**Entities:** `LocationPointEntity { riderId, lat, lng, speedKmh, heading, timestamp }`, `GeofenceEntity`

**UseCases:**
- `StartLiveTrackingUseCase` — starts GPS + broadcast
- `StopLiveTrackingUseCase` — stops GPS + broadcast + saves route batch
- `SubscribeToRidersUseCase` — subscribes to Realtime, emits `Stream<Map<String, LocationPoint>>`
- `GetRideRouteUseCase`
- `GetAllRiderRoutesUseCase`
- `CheckSpeedAlertUseCase(params: {speed, threshold})` → `bool`
- `CheckGeofenceAlertUseCase(params: {location, geofences})` → `GeofenceEntity?`
- `GetGeofencesUseCase`
- `AddGeofenceUseCase`
- `DeleteGeofenceUseCase`
- `ToggleGeofenceUseCase`

### Presentation Layer

**Cubits:**

`LiveMapCubit`:
```dart
sealed class LiveMapState {}
class LiveMapInitial extends LiveMapState {}
class LiveMapLoading extends LiveMapState {}
class LiveMapActive extends LiveMapState {
  final Map<String, LocationPointEntity> riderLocations;
  final LocationPointEntity myLocation;
  final double mySpeedKmh;
  final bool isFollowMode;
  final MapType mapType;
}
class LiveMapSpeedAlert extends LiveMapActive { final double speed; }
class LiveMapGeofenceAlert extends LiveMapActive { final GeofenceEntity zone; final bool entered; }
class LiveMapError extends LiveMapState { final String messageKey; }
```

`RideReplayCubit`

`GeofenceCubit`

**Screens:**

`LiveMapScreen`:
- Full-screen Google Map
- Custom motorcycle marker for each rider (SVG asset, rotates with heading)
- Tap rider marker → `RiderInfoPopup` overlay
- "Follow Mode" toggle — auto-centers map on current user
- Map type switcher: Normal / Satellite / Terrain
- Recenter button (if follow mode is off)
- Speed HUD (top-right corner): current speed in km/h
- Geofence zones drawn as circles on map
- Speed alert: screen flash + snack bar when threshold exceeded
- Geofence alert: snack bar when entering/exiting zone
- "I'm Safe" button (if in active ride)
- "Stop Ride" button (owner/admin only)

`RiderInfoPopup` (overlay — not a full screen):
- Shown on marker tap
- Rider name, profile photo, current speed, last seen time
- "I'm Safe" badge if rider has broadcast safe status
- Dismiss on tap outside

`RideReplayScreen`:
- Google Map with animated route
- `Slider` (timeline scrubber) — scrub through the route
- Speed at each point shown in HUD
- Play/Pause button
- Total distance + duration summary
- Multi-rider support: show all riders' routes with different colors

`GeofenceManagerScreen`:
- List of saved geofences (name, radius, active toggle)
- "Add Geofence" → opens map in draw mode: tap to set center, drag circle to set radius
- Delete geofence button
- Active/Inactive toggle per geofence

**Performance Rules (critical for this phase):**
- Rider markers: use `AnimatedMarker` or `MarkerLayer` update — do NOT recreate all markers on every location update
- Location updates: debounce map camera movement to prevent jitter
- `BlocSelector` to listen only to the specific rider's location that changed
- Maximum markers on screen: 50 (unlikely but handle gracefully)
- Background GPS must not drain battery excessively — use minimum 3-second interval

**Acceptance Criteria:**
- [ ] All riders visible on map with live position updates (≤3 second refresh)
- [ ] Rider markers rotate to show heading
- [ ] Tapping marker shows `RiderInfoPopup`
- [ ] Follow mode auto-centers on current user
- [ ] Speed HUD shows real GPS speed in km/h
- [ ] Speed alert triggers when threshold exceeded
- [ ] Geofence alert triggers on enter/exit
- [ ] GPS continues when app is minimized (foreground service Android, background mode iOS)
- [ ] On ride stop: full route batch-saved to Supabase
- [ ] Ride Replay animates correctly through the saved route
- [ ] Geofence CRUD works (add, toggle, delete)

---

## Phase 5 — Definition of Done

- [ ] Live GPS tracking works across iOS and Android
- [ ] Background GPS confirmed working (test by minimizing app during ride)
- [ ] Speed alerts functional
- [ ] Geofence alerts functional
- [ ] Route saved successfully at ride end
- [ ] Ride Replay renders and plays correctly
- [ ] Map performance: no jitter, smooth marker movement
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 5 tests pass
- [ ] Battery usage profiled — acceptable drain rate

---

---

# PHASE 6 — AI Riding Analysis

> **Goal:** After every completed ride, the app automatically generates an AI
> riding report with a score, natural language summary, and personalized tips.
> Historical scores are tracked. Weekly reports are generated. Fuel efficiency
> is logged and analyzed.

> **Prerequisite:** Phase 5 complete. Rides can be completed with route data.

---

## 6.1 Feature: AI Riding Analysis (Module 07)

**Screens:** Ride Report, Riding Score History, Weekly Report, Fuel Log, Add Fuel Entry

**Folder:** `lib/features/ai_analysis/`

### Data Layer

**Supabase Table:** `ride_reports`
```
id              UUID
ride_id         UUID (FK rides.id) UNIQUE
rider_id        UUID (FK users.id)
score           INTEGER (0-100)
score_label     ENUM (excellent, good, fair, needs_improvement)
summary         TEXT
tips            JSONB (array of strings)
hard_brake_count    INTEGER
rapid_accel_count   INTEGER
speed_violations    INTEGER
avg_speed_kmh       REAL
top_speed_kmh       REAL
total_distance_km   REAL
duration_minutes    INTEGER
created_at      TIMESTAMPTZ
```

**Supabase Table:** `fuel_logs`
```
id              UUID
motorcycle_id   UUID (FK motorcycles.id)
user_id         UUID (FK users.id)
liters_filled   REAL
mileage_at_fill INTEGER
cost            REAL NULLABLE
date            DATE
consumption_rate REAL NULLABLE (calculated: L/100km)
created_at      TIMESTAMPTZ
```

**Repository Implementation:** `AiAnalysisRepositoryImpl`
- `generateRideReport(rideId, riderId)` → calls `AiService.generateRideReport` → saves to `ride_reports` → `ApiResult<RideReportEntity>`
- `getRideReport(rideId)` → `ApiResult<RideReportEntity>` (from Supabase — cached, no re-generation)
- `getScoreHistory(userId, limit)` → `ApiResult<List<RideReportEntity>>`
- `getWeeklyReport(userId, weekStart)` → fetches from Edge Function (server-generated) → `ApiResult<WeeklyReportEntity>`
- `addFuelLog(params)` → `ApiResult<FuelLogEntity>` (calculates consumption rate before save)
- `getFuelLogs(motorcycleId)` → `ApiResult<List<FuelLogEntity>>`
- `deleteFuelLog(logId)` → `ApiResult<void>`

**AI Report Generation Flow:**
1. `StopRideUseCase` completes
2. Telemetry is aggregated from `ride_locations` (calculate: avg speed, top speed, hard braking events, rapid acceleration events, speed violations)
3. `AiAnalysisRepositoryImpl.generateRideReport()` is called
4. `AiService` sends request to Supabase Edge Function → Edge Function calls AI API
5. Response parsed → saved to `ride_reports`
6. `LiveMapCubit` / `ActiveRideCubit` navigates to `RideReportScreen`
7. If AI call fails: save telemetry locally, show "Report Generating..." state, retry in background

### Domain Layer

**Entities:** `RideReportEntity`, `WeeklyReportEntity`, `FuelLogEntity`
**Enum:** `ScoreLabel { excellent, good, fair, needsImprovement }`

**UseCases:**
- `GenerateRideReportUseCase`
- `GetRideReportUseCase`
- `GetScoreHistoryUseCase`
- `GetWeeklyReportUseCase`
- `AddFuelLogUseCase` (includes consumption rate calculation in domain layer)
- `GetFuelLogsUseCase`
- `DeleteFuelLogUseCase`

**Domain calculation (in UseCase, not data layer):**
- `FuelConsumptionCalculator.calculate(liters, distanceKm)` → `L/100km`
- `TelemetryAggregator.aggregate(locationPoints)` → braking/acceleration event count

### Presentation Layer

**Cubits:** `RideReportCubit`, `ScoreHistoryCubit`, `WeeklyReportCubit`, `FuelLogCubit`

**Screens:**

`RideReportScreen` (auto-shown after ride ends):
- Score badge (large, colored by label: green/blue/yellow/red)
- Score label text
- Breakdown cards: Speed, Braking, Acceleration (each with icon + value)
- AI summary text (natural language)
- Safety tips list
- Comparison to previous ride ("12% safer than last ride")
- Share button (screenshot or text share)
- "Done" → navigates to Dashboard

`RidingScoreHistoryScreen`:
- Line chart showing score trend (last 10 rides) using `fl_chart`
- List of rides below chart (date, score, label)
- Best ride highlighted in green, worst in red

`WeeklyReportScreen`:
- Summary card: total rides, total distance, average score for the week
- Score trend chart
- "Most common issue" section (e.g., "Hard braking was your main challenge")
- Comparison to previous week (+/- percentage)

`FuelLogScreen`:
- List of fuel entries (date, liters, mileage, cost)
- Average consumption (L/100km) card at top
- AI efficiency tip (from latest report or Edge Function)
- "Add Entry" FAB → `/fuel/add`

`AddFuelEntryScreen`:
- Fields: Liters filled, Mileage at fill-up, Cost (optional), Date
- Motorcycle picker (if user has multiple — defaults to primary)
- "Save" → calls `AddFuelLogUseCase`

**Acceptance Criteria:**
- [ ] Ride report auto-generates after ride stops
- [ ] Score and label display correctly
- [ ] AI summary and tips shown in selected language (Arabic/English)
- [ ] If AI fails, graceful fallback with retry option
- [ ] Score history chart renders with last 10 rides
- [ ] Weekly report fetched from Edge Function
- [ ] Fuel log CRUD works
- [ ] Consumption rate calculated correctly
- [ ] Share button works on iOS and Android

---

## Phase 6 — Definition of Done

- [ ] Full AI report flow works end-to-end (ride end → AI call → report shown)
- [ ] Graceful failure handling if AI API is unavailable
- [ ] Score history and weekly report render correctly
- [ ] Fuel log functional
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 6 tests pass

---

---

# PHASE 7 — Maintenance Tracking

> **Goal:** Riders can log all motorcycle maintenance activities, set reminders
> by time and mileage, view full service history, and receive AI-based predictions
> for upcoming maintenance needs.

> **Prerequisite:** Phase 2 complete (motorcycle profiles exist). Phase 6 preferred (AI service active).

---

## 7.1 Feature: Maintenance Tracking (Module 08)

**Screens:** Maintenance Overview, Add Log, Log Detail, History, Set Reminder, Calendar

**Folder:** `lib/features/maintenance/`

### Data Layer

**Supabase Table:** `maintenance_logs`
```
id              UUID
motorcycle_id   UUID (FK motorcycles.id)
user_id         UUID (FK users.id)
type            ENUM (oil_change, oil_filter, air_filter, spark_plugs, tires, brake_pads, chain, battery, coolant, custom)
custom_type     TEXT NULLABLE (used when type = custom)
date_performed  DATE
mileage_at_service INTEGER
cost            REAL NULLABLE
workshop        TEXT NULLABLE
notes           TEXT NULLABLE
created_at      TIMESTAMPTZ
```

**Supabase Table:** `maintenance_reminders`
```
id              UUID
motorcycle_id   UUID (FK motorcycles.id)
user_id         UUID (FK users.id)
type            ENUM (same as maintenance_logs.type)
custom_type     TEXT NULLABLE
interval_days   INTEGER NULLABLE
interval_km     INTEGER NULLABLE
last_service_date  DATE NULLABLE
last_service_mileage INTEGER NULLABLE
status          ENUM (ok, due_soon, overdue)
next_due_date   DATE NULLABLE (computed)
next_due_mileage INTEGER NULLABLE (computed)
created_at      TIMESTAMPTZ
updated_at      TIMESTAMPTZ
```

**Repository Implementation:** `MaintenanceRepositoryImpl`
- `getMaintenanceSummary(motorcycleId)` → `ApiResult<List<MaintenanceReminderEntity>>` (status for each type)
- `addLog(params)` → `ApiResult<MaintenanceLogEntity>` (also updates reminder `last_service_*` fields)
- `getLog(logId)` → `ApiResult<MaintenanceLogEntity>`
- `updateLog(params)` → `ApiResult<MaintenanceLogEntity>`
- `deleteLog(logId)` → `ApiResult<void>`
- `getHistory(motorcycleId, {year})` → `ApiResult<List<MaintenanceLogEntity>>`
- `setReminder(params)` → `ApiResult<MaintenanceReminderEntity>`
- `updateReminderStatus(motorcycleId)` → recomputes all statuses based on current mileage + date
- `getMaintenancePrediction(motorcycleId)` → calls `AiService.generateMaintenancePrediction` → `ApiResult<MaintenancePredictionEntity>`

### Domain Layer

**Entities:** `MaintenanceLogEntity`, `MaintenanceReminderEntity`, `MaintenancePredictionEntity`
**Enum:** `MaintenanceType`, `MaintenanceStatus { ok, dueSoon, overdue }`

**UseCases:**
- `GetMaintenanceSummaryUseCase`
- `AddMaintenanceLogUseCase`
- `GetMaintenanceLogUseCase`
- `UpdateMaintenanceLogUseCase`
- `DeleteMaintenanceLogUseCase`
- `GetMaintenanceHistoryUseCase`
- `SetMaintenanceReminderUseCase`
- `GetMaintenancePredictionUseCase`

**Status calculation logic (domain layer):**
- `status = overdue` if current date > `next_due_date` OR current mileage > `next_due_mileage`
- `status = due_soon` if within 7 days of `next_due_date` OR within 200km of `next_due_mileage`
- `status = ok` otherwise
- Both time and mileage thresholds checked — whichever triggers first

### Presentation Layer

**Cubits:** `MaintenanceSummaryCubit`, `MaintenanceLogCubit`, `MaintenanceHistoryCubit`, `MaintenanceReminderCubit`

**Screens:**

`MaintenanceOverviewScreen`:
- Status cards grid for each maintenance type:
  - Color: green (OK), orange (Due Soon), red (Overdue)
  - Shows type name, last service date, next due estimate
- AI prediction banner at top (if prediction available)
- "Add Log" FAB → `/maintenance/add`
- "View History" button → `/maintenance/history`

`AddMaintenanceLogScreen`:
- Type picker (dropdown with all maintenance types + Custom option)
- If Custom: text field for custom type name
- Date picker (date performed)
- Mileage at service (number input)
- Cost (optional)
- Workshop name (optional)
- Notes (optional)
- "Save" → calls `AddMaintenanceLogUseCase` → refreshes summary

`MaintenanceLogDetailScreen`:
- Full log entry details
- "Edit" button → opens edit form (same as Add screen, pre-filled)
- "Delete" button → confirmation dialog → `DeleteMaintenanceLogUseCase`

`MaintenanceHistoryScreen`:
- Chronological list of all service entries for selected motorcycle
- Filter by type
- Annual cost summary cards at top (current year + previous year)
- Infinite scroll / pagination (20 per page)

`SetMaintenanceReminderScreen`:
- Type picker
- Time interval: "Remind me every X days"
- Mileage interval: "Remind me every X km"
- Both can be set — whichever triggers first sends the notification
- "Save Reminder" → calls `SetMaintenanceReminderUseCase`
- Reminder scheduling pushed to Supabase Edge Function cron — not local notification

`MaintenanceCalendarScreen`:
- Monthly calendar view
- Past service entries shown as colored dots on their dates
- Upcoming reminders shown in future dates
- Color coding: green (OK), orange (Due Soon), red (Overdue)
- Tap date → shows log entries for that date

**Acceptance Criteria:**
- [ ] All 10 maintenance types have status cards
- [ ] Adding a log updates the reminder status
- [ ] Due Soon and Overdue states show correct colors
- [ ] AI prediction banner shows when prediction is available
- [ ] History screen shows full chronological list with annual cost
- [ ] Calendar correctly marks past services and upcoming reminders
- [ ] Reminder settings saved to Supabase (scheduling happens server-side)

---

## Phase 7 — Definition of Done

- [ ] Full maintenance CRUD works
- [ ] Status calculation correct for all scenarios
- [ ] AI prediction integration works
- [ ] Calendar renders correctly
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 7 tests pass

---

---

# PHASE 8 — Notifications System

> **Goal:** Users receive push notifications for all relevant events.
> In-app notification center shows history. Users can configure notification
> preferences and set quiet hours.

> **Prerequisite:** Phase 1 complete (FCM service initialized).

---

## 8.1 Feature: Notifications (Module 09)

**Screens:** Notification Center, Notification Preferences

**Folder:** `lib/features/notifications/`

### Data Layer

**Supabase Table:** `notifications`
```
id          UUID
user_id     UUID (FK users.id)
type        TEXT (matches FCM types from AGENT.md Section 6)
title       TEXT
body        TEXT
target_id   TEXT NULLABLE
is_read     BOOLEAN DEFAULT false
created_at  TIMESTAMPTZ
```

**Repository Implementation:** `NotificationRepositoryImpl`
- `getNotifications(userId, {page, limit: 20})` → `ApiResult<List<NotificationEntity>>`
- `markAsRead(notificationId)` → `ApiResult<void>`
- `markAllAsRead(userId)` → `ApiResult<void>`
- `getUnreadCount(userId)` → `ApiResult<int>`
- `getPreferences(userId)` → `ApiResult<NotificationPreferencesEntity>`
- `updatePreferences(params)` → `ApiResult<void>`

### Domain Layer

**Entities:** `NotificationEntity`, `NotificationPreferencesEntity`

**UseCases:**
- `GetNotificationsUseCase`
- `MarkNotificationReadUseCase`
- `MarkAllNotificationsReadUseCase`
- `GetUnreadCountUseCase`
- `GetNotificationPreferencesUseCase`
- `UpdateNotificationPreferencesUseCase`

### Presentation Layer

**Cubits:** `NotificationCubit`, `NotificationPreferencesCubit`

**Screens:**

`NotificationCenterScreen`:
- Full list of notifications (newest first)
- Unread notifications highlighted (different background)
- Unread count badge in app bar
- "Mark All as Read" button in app bar
- Tap notification → navigate to relevant screen (uses `NotificationHandler`)
- Pagination: 20 per page, load more on scroll
- Empty state if no notifications

`NotificationPreferencesScreen`:
- Toggle for each notification type:
  - Ride Updates (started/ended)
  - Speed Alerts
  - Geofence Alerts
  - Maintenance Reminders
  - Insurance/Registration Expiry
  - Group Activity (new member, invite)
  - Weekly Report
- Quiet Hours section: start time picker + end time picker
- "Save" button

**FCM Sending Architecture (server-side):**
Notifications are NEVER sent from the Flutter client. All FCM sends go through Supabase Edge Functions.
The Flutter client only:
1. Registers/refreshes FCM token in Supabase `users` table
2. Listens for incoming messages via `FcmService`
3. Saves received notifications to `notifications` table (or Edge Function does this)

**Acceptance Criteria:**
- [ ] All notification types received and displayed correctly
- [ ] Unread count badge shows correct number
- [ ] Mark all as read works
- [ ] Tapping notification navigates to correct screen
- [ ] Quiet hours prevents notifications during set time (server enforces this)
- [ ] Individual notification type toggles persist

---

## Phase 8 — Definition of Done

- [ ] Push notifications received for all types
- [ ] In-app notification center functional
- [ ] Preferences and quiet hours saved
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 8 tests pass

---

---

# PHASE 9 — Dashboard & Statistics

> **Goal:** The home screen gives riders a complete overview of their riding life:
> stats, charts, quick actions, and ride history. Detailed stats screens provide
> deep dives into distance, speed, score, fuel, and maintenance costs.

> **Prerequisite:** Phases 1–8 complete (all data sources exist).

---

## 9.1 Feature: Dashboard (Module 10)

**Screens:** Dashboard/Home, All Rides History, Ride Detail (from history), Stats (Distance, Speed, Score, Fuel, Maintenance Cost), Search

**Folder:** `lib/features/dashboard/`

### Data Layer

**Repository Implementation:** `DashboardRepositoryImpl`
- `getDashboardStats(userId)` → `ApiResult<DashboardStatsEntity>` (aggregated query)
- `getWeeklyRideFrequency(userId)` → `ApiResult<List<DailyRideCount>>` (last 7 days)
- `getMonthlyDistanceTrend(userId)` → `ApiResult<List<MonthlyDistance>>` (last 6 months)
- `getScoreTrend(userId, limit: 10)` → `ApiResult<List<ScorePoint>>`
- `getFuelTrend(userId)` → `ApiResult<List<FuelConsumptionPoint>>`
- `getAllRides(userId, {filters})` → `ApiResult<List<RideEntity>>` (paginated, with filters)
- `searchAll(query)` → `ApiResult<SearchResultsEntity>` (groups, riders, rides)

**Note:** Dashboard stats are aggregated — prefer Supabase RPCs (stored functions) over multiple round-trips. One `get_dashboard_stats(user_id)` RPC returns all needed values.

### Domain Layer

**Entities:** `DashboardStatsEntity`, `SearchResultsEntity`

**UseCases:**
- `GetDashboardStatsUseCase`
- `GetWeeklyRideFrequencyUseCase`
- `GetMonthlyDistanceTrendUseCase`
- `GetScoreTrendUseCase`
- `GetFuelTrendUseCase`
- `GetAllRidesUseCase`
- `SearchUseCase`

### Presentation Layer

**Cubits:** `DashboardCubit`, `RidesHistoryCubit`, `StatsCubit`, `SearchCubit`

**Screens:**

`DashboardScreen` (home tab):
- Stats row: Total Rides | Total Distance | Riding Hours | Top Speed
- Charts section (using `fl_chart`):
  - Weekly ride frequency → bar chart
  - Monthly distance trend → line chart (last 6 months)
  - Riding score trend → line chart (last 10 rides)
  - Fuel consumption trend → line chart (if fuel logs exist)
- Quick action cards: "Start Ride" | "Next Maintenance" | "Insurance Expiry" | "Latest AI Feedback"
- Pull-to-refresh
- Deep links from notification tap handled here

`AllRidesHistoryScreen`:
- Full paginated list of all rides
- Filter bar: date range picker + group picker + motorcycle picker
- Each ride card: date, group name, distance, duration, score badge
- Tap → `/home/rides/:rideId`

`RideDetailHistoryScreen`:
- Ride summary: date, duration, distance, group, motorcycle, score
- Mini-map showing route
- "Replay" button → `/ride-replay/:rideId`
- AI report preview card

`StatsDetailScreen — Distance`:
- Total all-time distance
- This week / This month breakdown
- Bar chart: daily distance (last 7 days)
- Line chart: monthly distance (last 6 months)

`StatsDetailScreen — Speed`:
- Average speed (all time + this month)
- Top speed ever recorded
- Speed distribution histogram (using `fl_chart`)

`StatsDetailScreen — Riding Score`:
- Current month average score
- All-time best and worst ride
- Score trend line chart (last 10 rides)
- Best/worst ride highlighted

`StatsDetailScreen — Fuel`:
- Average consumption (L/100km) — current motorcycle
- Consumption trend chart
- Total fuel cost (if cost was logged)

`StatsDetailScreen — Maintenance Cost`:
- Yearly cost breakdown (current year vs previous year)
- Pie chart by maintenance type (using `fl_chart`)

`SearchScreen`:
- Single search input at top
- Results split into sections: Groups | Riders | Rides
- Empty results state per section
- Tap result → navigate to appropriate screen

**Acceptance Criteria:**
- [ ] Dashboard stats load correctly from Supabase RPC
- [ ] All 4 charts render with real data
- [ ] Quick action cards navigate correctly
- [ ] Rides history pagination works (20 per page, load more on scroll)
- [ ] All filters on rides history work (date, group, motorcycle)
- [ ] Replay button on ride detail navigates to `RideReplayScreen`
- [ ] All 5 stats detail screens render correctly with charts
- [ ] Search returns results across groups, riders, and rides

---

## Phase 9 — Definition of Done

- [ ] Dashboard home screen fully functional with all charts
- [ ] All stats detail screens working
- [ ] Ride history with filters and pagination
- [ ] Search functional
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — all Phase 9 tests pass

---

---

# PHASE 10 — Polish, QA & Release Prep

> **Goal:** App is production-ready. All shared screens implemented.
> Cross-cutting concerns polished. Performance profiled. Release artifacts built.

> **Prerequisite:** Phases 0–9 complete.

---

## 10.1 Shared / Global Screens

**Screens:** No Internet, Error, Empty State, Loading/Skeleton, Bottom Nav (already built in Phase 0)

**Verify across all features:**
- [ ] Every screen that loads data shows `AppSkeleton` while loading
- [ ] Every screen with an error shows `ErrorWidget` with retry
- [ ] Every list screen with no data shows `EmptyStateWidget` with contextual CTA
- [ ] No internet state shows `NoInternetScreen` with cached data notice

---

## 10.2 Cross-Cutting Polish

**RTL & Localization audit:**
- [ ] Every screen tested in Arabic (RTL) — no misaligned elements
- [ ] Every screen tested in English (LTR)
- [ ] All date and number formats use `intl` locale formatting
- [ ] No hardcoded strings remaining (automated check: `grep -r '"[A-Z]' lib/features` should return zero results)

**Theme audit:**
- [ ] Every screen tested in Dark mode
- [ ] Every screen tested in Light mode
- [ ] No hardcoded colors remaining

**Performance profiling:**
- [ ] Live Map: 60fps during active ride with 10 riders
- [ ] Dashboard charts: render under 300ms
- [ ] App startup time: < 3 seconds on mid-range device

**Accessibility:**
- [ ] Minimum touch target size: 44x44pt on all tappable elements
- [ ] Semantic labels on all images and icon-only buttons
- [ ] Screen reader compatibility tested

---

## 10.3 Security Audit

- [ ] No secrets in Flutter code (automated: `grep -r "sk-" lib/` returns zero)
- [ ] Supabase `anon` key only in Flutter — `service_role` never present
- [ ] JWT stored in `flutter_secure_storage` — confirmed via code review
- [ ] Sensitive data fields never appear in logs
- [ ] Supabase RLS policies reviewed for all tables

---

## 10.4 Release Preparation

**Android:**
- [ ] App signing configured (release keystore)
- [ ] `build.gradle` version code and version name set
- [ ] ProGuard rules configured for all packages
- [ ] Google Play listing assets ready (screenshots, description, icon)
- [ ] `flutter build apk --release` succeeds

**iOS:**
- [ ] Bundle ID set: `com.motoorbito.app`
- [ ] Code signing configured (Distribution certificate + provisioning profile)
- [ ] `Info.plist` permissions: location (always + when in use), camera, photo library
- [ ] App Store listing assets ready
- [ ] `flutter build ipa --release` succeeds

**Final checks:**
- [ ] `flutter analyze` — zero issues
- [ ] `flutter test` — 100% of tests pass
- [ ] No debug `print()` statements
- [ ] No TODO comments left in production code
- [ ] App tested on physical devices: iPhone 14 (iOS 17), Samsung Galaxy S21 (Android 12)

---

## Phase 10 — Definition of Done

- [ ] App builds for both platforms in release mode
- [ ] Zero analyzer issues
- [ ] All tests pass
- [ ] Performance targets met
- [ ] Security audit passed
- [ ] RTL and localization audit passed
- [ ] Ready for App Store and Google Play submission

---

---

# PHASE 11 — SOS & Emergency *(Post-Job — Phase 2)*

> **Do not start until Phase 10 is complete and shipped.**

> **Goal:** Riders in distress can trigger an SOS that notifies emergency contacts
> via SMS and notifies group members in-app with a live location link.

---

## 11.1 Feature: SOS & Emergency (Module 11)

**Screens:** SOS Screen, SOS Active Screen

**New dependencies (require approval before Phase 11 starts):**
- SMS sending: via Supabase Edge Function + Twilio (server-side only)
- No new Flutter packages expected

### Specification

`SosScreen`:
- Large "Hold to Activate" button — requires 3-second press to prevent accidents
- Ring/progress animation during the 3-second hold
- "I'm OK" cancel button visible at all times
- Emergency contact name and phone displayed

`SosActiveScreen`:
- "SOS ACTIVE" banner
- Location sharing status ("Sharing location every 30 seconds")
- Countdown or timestamp of activation
- "Cancel Alert" button → shows confirmation before cancelling
- All group members receive in-app push notification with deep link

**Backend behavior (Edge Function):**
- On SOS trigger: send SMS to emergency contact with live location link
- Location shared every 30 seconds to a temporary Supabase table
- On cancel: stop sharing, send "All clear" SMS

**Acceptance Criteria:**
- [ ] 3-second hold required (no accidental triggers)
- [ ] Emergency contact receives SMS with location link
- [ ] Group members receive in-app notification
- [ ] "Cancel Alert" stops location sharing
- [ ] SOS works when app is in background

---

---

# PHASE 12 — Social Feed *(Post-Job — Phase 2)*

> **Do not start until Phase 10 is complete and shipped.**

> **Goal:** Riders can share posts with photos and text in a community feed.
> Auto-generated post option after completing a ride.

---

## 12.1 Feature: Social Feed (Module 12)

**Screens:** Social Feed, Create Post, Post Detail

**New Supabase Tables:** `posts`, `post_likes`, `post_comments`, `post_reports`

### Specification

`SocialFeedScreen`:
- Scrollable feed — two tabs: "My Groups" | "All Riders"
- Post card: author avatar + name, photo (if any), text, like count, comment count
- "Create Post" FAB
- Infinite scroll pagination

`CreatePostScreen`:
- Text input (max 500 characters)
- Photo attachment (up to 3 photos)
- "Tag a Ride" option — links post to a completed ride
- "Post" button

`PostDetailScreen`:
- Full post with all photos
- Comments list (with pagination)
- Add comment input
- Like button
- "Report Post" option (sends to moderation queue)

**Acceptance Criteria:**
- [ ] Posts appear in feed within 5 seconds of creation
- [ ] Photos upload and display correctly
- [ ] Like/comment counts update in real time (Supabase Realtime)
- [ ] Report post creates a record for manual moderation

---

---

# PHASE 13 — Group Chat *(Startup Vision — Phase 3)*

> **Do not start until the product team approves this milestone.**
> This is effectively a standalone chat application. Treat it as a separate scope.

---

## 13.1 Feature: Group Chat (Module 13)

**Screens:** Group Chat Screen, Chat Image Viewer

**New packages (require approval):**
- Real-time messaging: Supabase Realtime (already in stack) or dedicated chat service (evaluate at milestone start)

### Specification

**New Supabase Tables:** `group_messages`, `message_reads`, `pinned_messages`

`GroupChatScreen`:
- Messages list (newest at bottom)
- Text input + send button
- Image attachment (single photo)
- Location share button (sends current GPS location as a message)
- Message read receipts (double tick)
- "Pin message" option for owner/admin

`ChatImageViewerScreen`:
- Full-screen image viewer for images shared in chat
- Pinch to zoom, swipe to dismiss

**Key technical consideration:**
- Supabase Realtime for message streaming
- Messages paginated (load older messages on scroll up)
- Push notification for every new message (existing FCM infrastructure)

---

---

# PHASE 14 — Crash Detection *(Startup Vision — Phase 3)*

> **Do not start until Phase 13 is complete AND legal review is done.**
> **This feature requires extensive real-world testing before release.**
> **False positives on bumpy roads must be < 1%.**

---

## 14.1 Feature: Crash Detection (Module 14)

**Screen:** Crash Detection Settings

**New packages (require approval):**
- `sensors_plus` — accelerometer access

### Specification

`CrashDetectionSettingsScreen`:
- Enable/Disable toggle
- Sensitivity setting: Low / Medium / High
- "Test Alert" button (simulates a crash detection event — does not send real notifications)
- Legal disclaimer text
- Cannot be enabled without reading and accepting the disclaimer

**Detection Algorithm:**
- Monitor accelerometer via `sensors_plus`
- Crash signature: G-force spike > threshold AND speed drops from > 20 km/h to near 0 within 2 seconds
- On detection: start 30-second countdown with loud alert + vibration
- "I'm OK" button cancels within countdown
- If no response: trigger SOS flow (Phase 11 must be complete)

**Testing Requirements (before any release):**
- [ ] Tested on 5+ real-world road conditions (cobblestones, speed bumps, potholes)
- [ ] False positive rate < 1% over 50 test sessions
- [ ] Battery impact profiled when sensor polling is active
- [ ] Legal disclaimers reviewed by legal counsel

---

---

# Supabase Database Schema

> Complete table definitions for reference. All tables require RLS enabled.

```sql
-- USERS
CREATE TABLE users (
  id                        UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name                 TEXT NOT NULL,
  username                  TEXT UNIQUE NOT NULL,
  profile_photo             TEXT,
  phone                     TEXT,
  riding_experience         TEXT CHECK (riding_experience IN ('beginner', 'intermediate', 'expert')),
  riding_style              TEXT CHECK (riding_style IN ('city', 'highway', 'off_road', 'mixed')),
  language                  TEXT DEFAULT 'ar' CHECK (language IN ('ar', 'en')),
  dark_mode                 BOOLEAN DEFAULT false,
  fcm_token                 TEXT,
  speed_limit_kmh           INTEGER DEFAULT 120,
  emergency_contact_name    TEXT,
  emergency_contact_phone   TEXT,
  blood_type                TEXT CHECK (blood_type IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
  medical_notes             TEXT,
  created_at                TIMESTAMPTZ DEFAULT now(),
  updated_at                TIMESTAMPTZ DEFAULT now()
);

-- MOTORCYCLES
CREATE TABLE motorcycles (
  id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id               UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  make                  TEXT NOT NULL,
  model                 TEXT NOT NULL,
  year                  INTEGER NOT NULL,
  engine_cc             INTEGER,
  fuel_type             TEXT CHECK (fuel_type IN ('petrol', 'diesel', 'electric')),
  plate_number          TEXT,
  mileage_km            INTEGER DEFAULT 0,
  nickname              TEXT,
  is_primary            BOOLEAN DEFAULT false,
  insurance_expiry      DATE,
  registration_expiry   DATE,
  created_at            TIMESTAMPTZ DEFAULT now(),
  updated_at            TIMESTAMPTZ DEFAULT now()
);

-- MOTORCYCLE PHOTOS
CREATE TABLE motorcycle_photos (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  motorcycle_id   UUID NOT NULL REFERENCES motorcycles(id) ON DELETE CASCADE,
  url             TEXT NOT NULL,
  order_index     INTEGER DEFAULT 0,
  created_at      TIMESTAMPTZ DEFAULT now()
);

-- GROUPS
CREATE TABLE groups (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name            TEXT NOT NULL,
  description     TEXT,
  cover_photo     TEXT,
  is_public       BOOLEAN DEFAULT true,
  invite_code     TEXT UNIQUE NOT NULL,
  owner_id        UUID NOT NULL REFERENCES users(id),
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);

-- GROUP MEMBERS
CREATE TABLE group_members (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id    UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role        TEXT NOT NULL CHECK (role IN ('owner', 'admin', 'member')),
  joined_at   TIMESTAMPTZ DEFAULT now(),
  UNIQUE (group_id, user_id)
);

-- RIDES
CREATE TABLE rides (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id        UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  status          TEXT DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'active', 'completed', 'cancelled')),
  scheduled_at    TIMESTAMPTZ NOT NULL,
  meeting_point   JSONB NOT NULL,
  destination     JSONB,
  created_by      UUID NOT NULL REFERENCES users(id),
  started_at      TIMESTAMPTZ,
  ended_at        TIMESTAMPTZ,
  created_at      TIMESTAMPTZ DEFAULT now(),
  updated_at      TIMESTAMPTZ DEFAULT now()
);

-- RIDE PARTICIPANTS
CREATE TABLE ride_participants (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ride_id     UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  joined_at   TIMESTAMPTZ DEFAULT now(),
  is_safe     BOOLEAN DEFAULT false,
  UNIQUE (ride_id, user_id)
);

-- RIDE LOCATIONS (GPS points)
CREATE TABLE ride_locations (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ride_id     UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
  rider_id    UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  lat         DOUBLE PRECISION NOT NULL,
  lng         DOUBLE PRECISION NOT NULL,
  speed_kmh   REAL DEFAULT 0,
  heading     REAL DEFAULT 0,
  timestamp   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- RIDE REPORTS (AI-generated)
CREATE TABLE ride_reports (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ride_id             UUID NOT NULL REFERENCES rides(id) ON DELETE CASCADE,
  rider_id            UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  score               INTEGER CHECK (score BETWEEN 0 AND 100),
  score_label         TEXT CHECK (score_label IN ('excellent', 'good', 'fair', 'needs_improvement')),
  summary             TEXT,
  tips                JSONB,
  hard_brake_count    INTEGER DEFAULT 0,
  rapid_accel_count   INTEGER DEFAULT 0,
  speed_violations    INTEGER DEFAULT 0,
  avg_speed_kmh       REAL,
  top_speed_kmh       REAL,
  total_distance_km   REAL,
  duration_minutes    INTEGER,
  created_at          TIMESTAMPTZ DEFAULT now(),
  UNIQUE (ride_id, rider_id)
);

-- MAINTENANCE LOGS
CREATE TABLE maintenance_logs (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  motorcycle_id       UUID NOT NULL REFERENCES motorcycles(id) ON DELETE CASCADE,
  user_id             UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type                TEXT NOT NULL,
  custom_type         TEXT,
  date_performed      DATE NOT NULL,
  mileage_at_service  INTEGER,
  cost                REAL,
  workshop            TEXT,
  notes               TEXT,
  created_at          TIMESTAMPTZ DEFAULT now()
);

-- MAINTENANCE REMINDERS
CREATE TABLE maintenance_reminders (
  id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  motorcycle_id           UUID NOT NULL REFERENCES motorcycles(id) ON DELETE CASCADE,
  user_id                 UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type                    TEXT NOT NULL,
  custom_type             TEXT,
  interval_days           INTEGER,
  interval_km             INTEGER,
  last_service_date       DATE,
  last_service_mileage    INTEGER,
  status                  TEXT DEFAULT 'ok' CHECK (status IN ('ok', 'due_soon', 'overdue')),
  next_due_date           DATE,
  next_due_mileage        INTEGER,
  created_at              TIMESTAMPTZ DEFAULT now(),
  updated_at              TIMESTAMPTZ DEFAULT now()
);

-- FUEL LOGS
CREATE TABLE fuel_logs (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  motorcycle_id     UUID NOT NULL REFERENCES motorcycles(id) ON DELETE CASCADE,
  user_id           UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  liters_filled     REAL NOT NULL,
  mileage_at_fill   INTEGER NOT NULL,
  cost              REAL,
  date              DATE NOT NULL DEFAULT CURRENT_DATE,
  consumption_rate  REAL,
  created_at        TIMESTAMPTZ DEFAULT now()
);

-- NOTIFICATIONS
CREATE TABLE notifications (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  type        TEXT NOT NULL,
  title       TEXT NOT NULL,
  body        TEXT NOT NULL,
  target_id   TEXT,
  is_read     BOOLEAN DEFAULT false,
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- GEOFENCES
CREATE TABLE geofences (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  name            TEXT NOT NULL,
  center_lat      DOUBLE PRECISION NOT NULL,
  center_lng      DOUBLE PRECISION NOT NULL,
  radius_meters   INTEGER NOT NULL DEFAULT 500,
  is_active       BOOLEAN DEFAULT true,
  created_at      TIMESTAMPTZ DEFAULT now()
);
```

---

# Edge Functions Map

> All server-side logic lives here. The Flutter app never calls AI APIs or sends
> SMS/FCM directly. These functions are triggered by Supabase webhooks, cron jobs,
> or direct HTTP calls from the Flutter app via `BaseApiClient`.

| Function Name                    | Trigger              | Purpose                                                    |
|----------------------------------|----------------------|------------------------------------------------------------|
| `generate-ride-report`           | HTTP (post-ride)     | Calls AI API → saves result to `ride_reports`              |
| `generate-weekly-report`         | Cron (every Monday)  | Aggregates week data → calls AI → saves weekly report      |
| `generate-maintenance-prediction`| HTTP (on demand)     | Calls AI → returns prediction (not persisted long-term)    |
| `send-fcm-notification`          | HTTP (internal)      | Sends FCM push to target user(s) FCM token                 |
| `send-sos-sms`                   | HTTP (SOS trigger)   | Sends SMS via Twilio to emergency contact                  |
| `check-expiry-reminders`         | Cron (daily at 8am)  | Checks insurance/registration expiry → triggers FCM        |
| `check-maintenance-reminders`    | Cron (daily at 8am)  | Checks time/mileage thresholds → triggers FCM              |
| `delete-user`                    | HTTP (account delete)| Deletes auth user + cascades cleanup + revokes tokens      |
| `regenerate-invite-code`         | HTTP (owner request) | Generates new unique 6-digit code → updates `groups`       |
| `get-dashboard-stats`            | HTTP (RPC)           | Aggregated stats query → returns all dashboard data        |

---

*Last updated: Project initialization*
*Moto Orbito — "Ride Together, Stay in Orbit"*
*Phases 0–10 = Phase 1 product. Phases 11–14 = Roadmap.*
