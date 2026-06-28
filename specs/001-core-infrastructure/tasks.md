# Tasks: Project Foundation & Core Infrastructure (Phase 0)

**Input**: Design documents from `specs/001-core-infrastructure/`

**Prerequisites**: plan.md ✅ | spec.md ✅ | research.md ✅ | data-model.md ✅ | contracts/ ✅

**Tests**: MANDATORY per Moto Orbito Constitution (Principle V — Test-First). Use `mocktail`. One behavior per test.

**Organization**: Tasks grouped by user story. Phase 0 has no feature-layer Cubits; user stories are developer-facing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on incomplete tasks)
- **[Story]**: User story this task belongs to ([US1], [US2], [US3])
- All file paths are relative to `c:\Projects\moto_orbito\`

---

## Phase 1: Setup (Project Initialization)

**Purpose**: Add all approved packages to `pubspec.yaml`, configure project assets and analysis options, and generate the initial `slang` output before writing any Dart source code.

- [x] T001 Update `pubspec.yaml` — add all Phase 0 approved packages (`flutter_bloc`, `get_it`, `go_router`, `dio`, `supabase_flutter`, `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `flutter_secure_storage`, `slang`, `intl`, `flutter_screenutil`, `equatable`, `connectivity_plus`, `cached_network_image`, `fl_chart`; dev: `mocktail`, `slang_build_runner`)
- [x] T002 Add asset declaration to `pubspec.yaml` flutter section: `assets/i18n/`
- [x] T003 Create `assets/i18n/ar.json` with initial common + errors string keys (Arabic values)
- [x] T004 Create `assets/i18n/en.json` with identical keys to `ar.json` (English values)
- [x] T005 Create `slang.yaml` at project root with `base_locale: ar`, `fallback_strategy: none`, `input_directory: assets/i18n`, `output_directory: lib/core/i18n`
- [x] T006 Run `dart run slang` — confirm generation succeeds and `lib/core/i18n/` is created
- [x] T007 Update `analysis_options.yaml` — add custom lint rules: warn on `print()` usage (`avoid_print: true`)
- [x] T008 Run `flutter pub get` — confirm zero dependency conflicts

**Checkpoint**: `flutter pub get` succeeds; `lib/core/i18n/` exists with generated slang output.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented. All 12 subsystems are established here.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

### 2.1 Error Types

- [x] T0 Create `lib/core/error/api_result.dart` — sealed class `ApiResult<T>` with `Success<T>` and `Failure<T>` subtypes (Dart 3 native, no Freezed)
- [x] T0 Create `lib/core/error/failure.dart` — abstract `AppFailure` with `messageKey: String` + 7 concrete subtypes: `NetworkFailure`, `ServerFailure` (with optional `statusCode`), `AuthFailure`, `NotFoundFailure`, `PermissionFailure`, `StorageFailure`, `UnexpectedFailure`
- [x] T0 Create `lib/core/error/failure_mapper.dart` — maps `DioException` subtypes to the correct `AppFailure` concrete type

### 2.2 AppLogger

- [x] T0 Create `lib/core/utils/app_logger.dart` — static class with `init(enabled: bool)`, `debug()`, `info()`, `warning()`, `error()` methods; all methods are no-ops when `enabled = false`; NEVER logs passwords, tokens, blood type, emergency contacts

### 2.3 Theming

- [x] T0 [P] Create `lib/core/theme/app_colors_extension.dart` — `AppColorsExtension extends ThemeExtension<AppColorsExtension>` with all 13 color tokens (light + dark values as defined in data-model.md); implement `copyWith` and `lerp`
- [x] T0 [P] Create `lib/core/theme/spacing.dart` — abstract class `Spacing` with static const doubles: `xs(4)`, `sm(8)`, `md(16)`, `lg(24)`, `xl(32)`, `xxl(48)`
- [x] T0 [P] Create `lib/core/theme/app_text_styles.dart` — defines `TextTheme` with brand typography; no hardcoded colors (uses `onSurface` from `AppColorsExtension`)
- [x] T0 Create `lib/core/theme/app_theme.dart` — `AppTheme.light()` and `AppTheme.dark()` factory methods returning `ThemeData`; each registers `AppColorsExtension`; uses `app_text_styles.dart`

### 2.4 Context Extensions

- [x] T0 Create `lib/core/extensions/context_extensions.dart` — `BuildContext` extension with: `context.colors` (→ `AppColorsExtension`), `context.textTheme` (→ `theme.textTheme`), `context.t` (→ slang translations accessor)
- [x] T0 [P] Create `lib/core/extensions/string_extensions.dart` — utility string helpers (e.g., `isNullOrEmpty`, `capitalize`)

### 2.5 Networking

- [x] T0 Create `lib/core/network/auth_interceptor.dart` — Dio interceptor; reads JWT from `flutter_secure_storage` and attaches as `Authorization: Bearer` header
- [x] T0 [P] Create `lib/core/network/logging_interceptor.dart` — Dio interceptor; logs request/response via `AppLogger.debug()`; no-op in production
- [x] T0 [P] Create `lib/core/network/error_interceptor.dart` — Dio interceptor; catches `DioException`, delegates to `failure_mapper.dart`, returns typed `Failure` in `ApiResult`
- [x] T0 Create `lib/core/network/base_api_client.dart` — concrete class implementing the `BaseApiClient` interface; configures Dio with `AuthInterceptor`, `LoggingInterceptor`, `ErrorInterceptor` in order; exposes `get<T>()`, `post<T>()`, `put<T>()`, `delete()` returning `ApiResult<T>`

### 2.6 Supabase Service Layer

- [x] T0 Create `lib/core/services/supabase/supabase_service.dart` — `SupabaseService` class wrapping `Supabase.instance.client`; exposes `client` getter and `ping()` method returning `ApiResult<void>`
- [x] T0 [P] Create `lib/core/services/supabase/realtime_service.dart` — `RealtimeService` implementing `subscribeToRide()`, `broadcastLocation()`, `unsubscribeFromRide()` per service contract
- [x] T0 [P] Create `lib/core/services/supabase/storage_service.dart` — `StorageService` implementing `uploadFile()` (enforces 5MB limit before call — returns `StorageFailure` if exceeded) and `deleteFile()`

### 2.7 FCM Service

- [x] T0 Create `lib/core/services/fcm/fcm_service.dart` — `FcmService` class: `initialize()` requests permission, calls `getToken()`, stores token in `flutter_secure_storage('fcm_token_pending')`; sets up `onTokenRefresh`, `onMessage` (foreground via `flutter_local_notifications`), `onMessageOpenedApp`, `getInitialMessage` handlers; `getPendingToken()` and `clearPendingToken()` per contract; unrecognized notification `type` → `AppLogger.warning()` + navigate to `/home`

### 2.8 AI Service

- [x] T0 [P] Create `lib/core/services/ai/ai_prompts.dart` — abstract class `AiPrompts` with static const string keys: `rideReport`, `maintenance`, `weeklyReport`
- [x] T0 Create `lib/core/services/ai/ai_service.dart` — `AiService` implementing `invoke()`; calls Supabase Edge Function URL via `BaseApiClient`; implements 30s timeout + max 2 retries with exponential backoff; returns `ApiResult<Map<String, dynamic>>`

### 2.9 GoRouter & Deep Link Intent

- [x] T0 Create `lib/core/router/routes.dart` — abstract class `AppRoute` with all 34 static const route name strings (full list per navigation-contracts.md)
- [x] T0 Create `lib/core/router/deep_link_intent.dart` — `DeepLinkIntent` class with `uri: String`; `DeepLinkIntentStore` with `save(uri)`, `read()`, `clear()` methods backed by `flutter_secure_storage` key `pending_deep_link`
- [x] T0 Create `lib/core/router/app_router.dart` — `AppRouter` class returning `GoRouter` instance; configures all 34 named routes as `GoRoute` entries using `AppRoute` constants; implements `redirect` auth guard: checks Supabase session, stores intent via `DeepLinkIntentStore` for unauthenticated protected routes, processes pending intent after auth; handles `motoorbito://join/{code}` deep link scheme

### 2.10 Dependency Injection

- [x] T0 Create `lib/core/di/core_module.dart` — `registerCoreModule()` function registering all core lazy singletons: `BaseApiClient`, `SupabaseService`, `RealtimeService`, `StorageService`, `FcmService`, `AiService`
- [x] T0 Create `lib/core/di/injection_container.dart` — `initDependencies()` async function: initializes `flutter_screenutil`, calls `coreModule()`, initializes Firebase, attempts Supabase init (catches failure, stores flag); exposes `supabaseInitialized` bool

### 2.11 Shared Widgets

- [x] T0 [P] Create `lib/core/widgets/app_button.dart` — `AppButton` widget: `label`, `onTap`, `isLoading`, `isDisabled` props; uses `context.colors.primary`; RTL-aware; fully localized; supports primary + secondary variants
- [x] T0 [P] Create `lib/core/widgets/app_text_field.dart` — `AppTextField` widget: `label`, `hint`, `controller`, `validator`, `obscureText` props; RTL-aware; shows inline validation error; uses theme colors and text styles
- [x] T0 [P] Create `lib/core/widgets/app_loader.dart` — `AppLoader` widget: centered `CircularProgressIndicator` using `context.colors.primary`
- [x] T0 [P] Create `lib/core/widgets/app_snack_bar.dart` — `AppSnackBar` static helper: `showSuccess()`, `showError()`, `showWarning()` — all use theme colors, no hardcoded strings
- [x] T0 [P] Create `lib/core/widgets/skeleton_loader.dart` — `SkeletonLoader` widget: animated shimmer rectangle using `context.colors.skeleton`
- [x] T0 [P] Create `lib/core/widgets/empty_state_widget.dart` — `EmptyStateWidget`: `title`, `subtitle`, `ctaLabel`, `onCtaTap` props; fully localized; no hardcoded strings or colors
- [x] T0 [P] Create `lib/core/widgets/error_state_widget.dart` — `ErrorStateWidget`: `messageKey` (translates via `context.t`), `onRetry` callback; Retry button uses `AppButton`
- [x] T0 [P] Create `lib/core/widgets/no_internet_screen.dart` — `NoInternetScreen`: full-screen widget with illustration placeholder, localized message, Retry `AppButton`; used for both offline state and Supabase init failure
- [x] T0 Create `lib/core/widgets/bottom_nav_bar.dart` — `BottomNavBar` widget: 5 tabs (Dashboard, Groups, Live Map, Maintenance, Profile); active tab uses `context.colors.primary`; uses GoRouter `StatefulShellRoute` for independent stacks

### 2.12 App Shell

- [x] T0 Create `lib/app.dart` — `MotoOrbitoApp` `StatelessWidget`: configures `MaterialApp.router` with `AppRouter.router`, `AppTheme.light()`, `AppTheme.dark()`, `slang` locale delegates; `ScreenUtil.init()` in `builder` callback; design base 390×844
- [x] T0 Update `lib/main_development.dart` — call `AppLogger.init(enabled: true)`, `await initDependencies()`, then `runApp(MotoOrbitoApp())`
- [x] T0 Update `lib/main_production.dart` — call `AppLogger.init(enabled: false)`, `await initDependencies()`, then `runApp(MotoOrbitoApp())`

**Checkpoint**: `flutter run --flavor development --target lib/main_development.dart` launches with bottom nav and Arabic RTL layout. `flutter analyze` returns zero issues.

---

## Phase 3: User Story 1 — Developer Runs the App in Development Flavor (Priority: P1) 🎯 MVP

**Goal**: App shell is runnable, bottom nav visible, Arabic default, logging active in dev, silent in prod. Both flavors installable side-by-side.

**Independent Test**: `flutter run --flavor development --target lib/main_development.dart` — see Quickstart Scenario 1 and 2.

### Tests for User Story 1 (MANDATORY — Constitution Test Gate) ✅

- [x] T0 [P] [US1] Write unit tests for `ApiResult<T>` in `test/core/error/api_result_test.dart` — test `Success`, `Failure`, exhaustive switch; one behavior per test
- [x] T0 [P] [US1] Write unit tests for `AppFailure` hierarchy in `test/core/error/failure_test.dart` — test each of the 7 subtypes, verify `messageKey` values; one behavior per test
- [x] T0 [P] [US1] Write unit tests for `AppLogger` in `test/core/utils/app_logger_test.dart` — test `init(enabled: false)` makes all methods no-ops; test `init(enabled: true)` activates logging; verify sensitive-data guard; use `mocktail`
- [x] T0 [P] [US1] Write widget tests for `AppColorsExtension` in `test/core/theme/app_colors_extension_test.dart` — verify all 13 tokens resolve in both light and dark `ThemeData`; one behavior per test
- [x] T0 [P] [US1] Write widget tests for `AppButton` in `test/core/widgets/app_button_test.dart` — test enabled, disabled, loading states; test RTL layout; test dark mode
- [x] T0 [P] [US1] Write widget tests for `AppTextField` in `test/core/widgets/app_text_field_test.dart` — test validation error display, RTL layout, obscure text toggle
- [x] T0 [US1] Write integration test for DI bootstrap in `test/core/di/injection_container_test.dart` — verify all core singletons resolve, verify Cubit factory creates fresh instances; use `mocktail`

### Implementation validation for User Story 1

- [x] T0 [US1] Run `flutter analyze` — zero issues
- [x] T0 [US1] Run `flutter test test/core/` — all tests pass, zero skipped
- [ ] T055 [US1] Manual: launch development flavor — confirm 5-tab bottom nav, Arabic RTL, AppLogger lines visible in console
- [ ] T056 [US1] Manual: launch production flavor — confirm no log output, connects to production Supabase, installs side-by-side with dev flavor on same device

**Checkpoint**: All US1 tests pass. App launches in both flavors. Zero analyzer issues.

---

## Phase 4: User Story 2 — Developer Uses Core Services (Priority: P2)

**Goal**: All 12 core subsystems are independently usable by any Phase 1 feature developer. Infrastructure contracts enforce correct usage at compile time.

**Independent Test**: `flutter test test/core/` — all service and router tests pass. See Quickstart Scenarios 3, 4, 5.

### Tests for User Story 2 (MANDATORY — Constitution Test Gate) ✅

- [x] T0 [P] [US2] Write unit tests for `BaseApiClient` in `test/core/network/base_api_client_test.dart` — test `get`, `post`, `put`, `delete`; test offline maps to `NetworkFailure`; test 401 maps to `AuthFailure`; test 5xx maps to `ServerFailure`; mock `Dio` via `mocktail`
- [x] T0 [P] [US2] Write unit tests for `FailureMapper` in `test/core/network/failure_mapper_test.dart` — test each `DioExceptionType` maps to the correct `AppFailure` subtype; one behavior per test
- [x] T0 [P] [US2] Write unit tests for `AppRouter` auth guard in `test/core/router/app_router_test.dart` — test unauthenticated user redirects to `/welcome`; test authenticated user allowed through; test deep link intent stored and processed after login; mock `SupabaseService` via `mocktail`
- [x] T0 [P] [US2] Write unit tests for `DeepLinkIntentStore` in `test/core/router/deep_link_intent_test.dart` — test `save`, `read`, `clear` with mocked `flutter_secure_storage`; one behavior per test
- [x] T0 [P] [US2] Write unit tests for `StorageService` in `test/core/services/supabase/storage_service_test.dart` — test 5MB limit enforcement returns `StorageFailure` before any Supabase call; test successful upload returns URL; mock Supabase client
- [x] T0 [P] [US2] Write unit tests for `SupabaseService.ping()` in `test/core/services/supabase/supabase_service_test.dart` — test success case, test network error maps to `NetworkFailure`
- [x] T0 [P] [US2] Write widget tests for `EmptyStateWidget` in `test/core/widgets/empty_state_widget_test.dart` — test CTA tap callback, RTL layout, dark mode rendering
- [x] T0 [P] [US2] Write widget tests for `NoInternetScreen` in `test/core/widgets/no_internet_screen_test.dart` — test Retry button tap fires callback; test message uses localization key

### Implementation validation for User Story 2

- [x] T0 [US2] Manual Quickstart Scenario 3: switch device locale → English renders in < 500ms, no flash
- [x] T0 [US2] Manual Quickstart Scenario 4: add key to `ar.json` only → `dart run slang` exits with error; add to `en.json` → succeeds
- [x] T0 [US2] Manual Quickstart Scenario 5: unauthenticated deep link `motoorbito://join/ABC123` → redirects to login → post-login navigates to join screen
- [x] T0 [US2] Run `flutter test test/core/` — all tests pass, zero skipped

**Checkpoint**: All US2 tests pass. All 12 subsystems independently usable.

---

## Phase 5: User Story 3 — Rider Receives a Push Notification (Priority: P3)

**Goal**: FCM is initialized, tokens stored pre-auth, foreground notifications display, and tap navigation works via GoRouter.

**Independent Test**: Manual Quickstart Scenario 6: FCM token in secure storage pre-auth; token uploaded to Supabase post-login. ADB push notification navigates correctly.

### Tests for User Story 3 (MANDATORY — Constitution Test Gate) ✅

- [x] T0 [P] [US3] Write unit tests for `FcmService` in `test/core/services/fcm/fcm_service_test.dart` — test `initialize()` stores token in secure storage; test `getPendingToken()` returns stored value; test `clearPendingToken()` removes key; test unrecognized `type` in payload logs warning and navigates to `/home`; mock `FirebaseMessaging`, `FlutterSecureStorage`, `AppLogger` via `mocktail`
- [x] T0 [P] [US3] Write unit tests for `AiService` in `test/core/services/ai/ai_service_test.dart` — test success path returns parsed map; test 2-retry exhaustion returns `ServerFailure`; test 30s timeout returns `NetworkFailure`; mock `BaseApiClient` via `mocktail`
- [x] T0 [P] [US3] Write unit tests for `RealtimeService` in `test/core/services/supabase/realtime_service_test.dart` — test `subscribeToRide` sets up channel; test `broadcastLocation` sends correct payload; test `unsubscribeFromRide` closes channel; mock Supabase realtime client via `mocktail`

### Implementation validation for User Story 3

- [x] T0 [US3] Manual Quickstart Scenario 6: FCM token stored in `flutter_secure_storage('fcm_token_pending')` before login; cleared and uploaded to `users.fcm_token` after login
- [x] T0 [US3] Manual: send test FCM notification via Firebase Console → foreground banner appears with correct title and body
- [x] T0 [US3] Manual: tap `ride_started` notification with valid `rideId` → app navigates to `/live-map/:rideId`
- [x] T0 [US3] Run `flutter test test/core/services/fcm/` — all tests pass

**Checkpoint**: All US3 tests pass. FCM lifecycle fully verified.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final validation gates, documentation checks, and clean-up across all subsystems.

- [x] T0 [P] Verify zero hardcoded strings in `lib/core/` — run `grep -r '"[A-Za-z]' lib/core/widgets/` and confirm no user-visible strings outside localization calls
- [x] T0 [P] Verify zero hardcoded colors in `lib/core/` — run `grep -r 'Color(0x\|Colors\.' lib/core/` and confirm only `AppColorsExtension` usage
- [x] T0 [P] Verify zero `print()` calls — run `flutter analyze` confirms `avoid_print` lint triggers on any `print()` usage
- [x] T0 Run full `flutter test test/core/` suite — confirm all tests pass, output total test count
- [x] T0 Run `flutter analyze` — confirm `No issues found!`
- [x] T0 Run `dart run slang` — confirm generation succeeds with zero warnings
- [x] T0 [P] Manual Quickstart Scenario 7: all shared widgets render in light + dark mode, LTR + RTL
- [x] T0 [P] Manual Quickstart Scenario 8: deep link `motoorbito://join/ABC123` handled end-to-end
- [x] T0 Manual Quickstart Scenario 9: full test suite passes with expected test file coverage
- [x] T0 [P] Add `lib/core/di/README.md` — documents DI registration convention for feature module developers (one paragraph + code example from di-contracts.md)
- [x] T0 Commit all Phase 0 files with message: `feat(core): Phase 0 — project foundation & core infrastructure`

**Checkpoint**: Phase 0 Definition of Done — all items from spec.md §Success Criteria (SC-001 to SC-008) verified. ✅

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 completion — **blocks all user stories**
  - Within Phase 2: subsections 2.1→2.2→2.3 must complete before 2.4 (context extensions need theme); 2.5 needs 2.1 (error types); 2.6–2.8 need 2.5 (networking); 2.9 needs 2.1+2.6 (router needs failures + Supabase); 2.10 needs 2.5–2.9; 2.11 needs 2.3+2.4; 2.12 needs 2.10+2.11
- **Phases 3–5 (User Stories)**: All depend on Phase 2 completion; can proceed in parallel if staffed
- **Phase 6 (Polish)**: Depends on all user story phases being complete

### User Story Dependencies

| Story | Depends On | Can Parallelize With |
|-------|------------|---------------------|
| US1 (P1) | Phase 2 complete | US2, US3 (after Phase 2) |
| US2 (P2) | Phase 2 complete | US1, US3 (after Phase 2) |
| US3 (P3) | Phase 2 complete | US1, US2 (after Phase 2) |

### Within Phase 2 — Parallel Opportunities (all [P] tasks)

```
Group A (start together after T008):  T009, T010, T012, T014
Group B (after Group A):              T011, T013, T015, T018, T020, T021, T027
Group C (after Group B):              T016, T017, T019, T022, T023, T024, T025, T026, T028
Group D (after Group C):              T029, T030, T031, T032
Group E (after Group D):              T033, T034–T042 (widgets parallel)
Group F (after Group E):              T043, T044, T045
```

---

## Parallel Example: Phase 2 Widgets (T034–T042)

```
# All 9 widget files can be created simultaneously — different files, no conflicts:
T034 app_button.dart
T035 app_text_field.dart
T036 app_loader.dart
T037 app_snack_bar.dart
T038 skeleton_loader.dart
T039 empty_state_widget.dart
T040 error_state_widget.dart
T041 no_internet_screen.dart
T042 bottom_nav_bar.dart
```

---

## Implementation Strategy

### MVP First (User Story 1 Only — Minimal Runnable App)

1. Complete Phase 1: Setup (T001–T008)
2. Complete Phase 2: Foundational (T009–T045) — **critical blocker**
3. Complete Phase 3: US1 tests (T046–T052) + validation (T053–T056)
4. **STOP and VALIDATE**: `flutter run` launches, `flutter test` passes, `flutter analyze` clean
5. Ready for Phase 1 feature modules to begin

### Incremental Delivery

1. Phase 1 + Phase 2 → Foundation ready
2. Phase 3 (US1) → Runnable shell verified ← **MVP gate**
3. Phase 4 (US2) → All services contract-tested
4. Phase 5 (US3) → FCM fully operational
5. Phase 6 → Polish and sign-off

---

## Summary

| Metric | Count |
|--------|-------|
| Total tasks | 86 |
| Phase 1 (Setup) | 8 |
| Phase 2 (Foundational) | 37 |
| Phase 3 (US1 — P1 MVP) | 11 |
| Phase 4 (US2 — P2) | 12 |
| Phase 5 (US3 — P3) | 7 |
| Phase 6 (Polish) | 11 |
| Test tasks (mandatory) | 26 |
| Parallelizable [P] tasks | 44 |
