# Feature Specification: Project Foundation & Core Infrastructure (Phase 0)

**Feature Branch**: `001-core-infrastructure`

**Created**: 2026-06-28

**Status**: Draft

**Source**: `PLAN.md` — PHASE 0

---

## Overview

This specification covers the entire foundational infrastructure that every subsequent
feature phase depends on. At the end of this phase the app MUST be runnable — showing
a blank shell with bottom navigation — but contain zero product features. Every
architectural pattern, shared service, and design system primitive is established here.

---

## Clarifications

### Session 2026-06-28

- Q: When Supabase initialization fails at app launch (no network), what should the app do? → A: Show a no-connection screen with a Retry button; app waits for connectivity before proceeding.
- Q: When the FCM token is obtained before the user authenticates, how should it be handled? → A: Store the token locally in secure storage; upload to Supabase `users.fcm_token` on successful login.
- Q: When a translation key exists in `ar.json` but is missing in `en.json`, what should happen? → A: `dart run slang` MUST fail with an error — missing secondary-locale keys are a build blocker.
- Q: If a user taps an invite link but isn't logged in, what happens to the invite code? → A: Store the deep link intent locally, redirect to auth, and automatically process the invite after successful login.
- Q: Should `Failure` objects evaluate translations or just store keys? → A: `Failure` stores the raw string key only; the UI layer uses `context.t` to translate it before display.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Developer Runs the App in Development Flavor (Priority: P1)

A developer on the team clones the repository, runs the development flavor, and sees a
blank shell application connected to the development Supabase project with full logging
active. The app renders correctly in both Arabic (RTL) and English.

**Why this priority**: Without a runnable app shell, no subsequent development can occur.
This is the absolute foundation gate.

**Independent Test**: Run `flutter run --flavor development --target lib/main_development.dart`
and confirm the app launches, bottom navigation is visible, Arabic is the default language,
and logs appear in the console.

**Acceptance Scenarios**:

1. **Given** the repository is cloned and dependencies installed, **When** the developer
   runs the development flavor, **Then** the app launches without errors, shows a
   bottom navigation bar with 5 tabs, renders in Arabic by default, and all console
   logs are visible.

2. **Given** the development flavor is running, **When** the developer switches the
   device locale to English, **Then** the app re-renders all visible text in English
   without a restart.

3. **Given** the production flavor is built, **When** it runs on a device, **Then** no
   debug logs appear in the console, the app connects to the production Supabase project,
   and both flavors can be installed side-by-side on the same Android device.

---

### User Story 2 — Developer Uses Core Services Without Writing Infrastructure Code (Priority: P2)

A feature developer building any Phase 1+ module can import and use pre-built core
services — dependency injection, navigation, networking, Supabase, FCM, AI, theming,
shared widgets, and localization — without setting up any infrastructure themselves.
All patterns are enforced by the infrastructure; deviations cause a compile or lint error.

**Why this priority**: The core infrastructure is the contract that all feature teams
depend on. If services are missing or incorrectly structured, every subsequent module
is blocked.

**Independent Test**: A developer creates a minimal Cubit that depends on a UseCase,
registers it via GetIt, and navigates to a placeholder screen — all infrastructure
works without additional configuration.

**Acceptance Scenarios**:

1. **Given** GetIt is initialized, **When** a feature module registers its Cubit,
   UseCase, and Repository, **Then** all three resolve correctly from the DI container
   with the correct lifecycle (factory for Cubits, lazy singleton for UseCases and
   Repositories).

2. **Given** a named route is defined in `routes.dart`, **When** the developer navigates
   to it using its name, **Then** GoRouter routes correctly, and the auth guard
   redirects unauthenticated users to the welcome screen.

3. **Given** the `BaseApiClient` is used for an HTTP call, **When** the device is
   offline, **Then** a `NetworkFailure` is returned (not a raw exception), and the UI
   can display an appropriate error message from the localization system.

4. **Given** a widget uses `context.colors.primary`, **When** the app theme switches
   between light and dark mode, **Then** the color updates correctly without any
   hardcoded color values.

---

### User Story 3 — Rider Receives a Push Notification (Priority: P3)

A rider's device registers with Firebase Cloud Messaging on app launch. When a
server-side event triggers a push notification, the rider sees it even while the app
is in the foreground, and tapping it navigates to the correct screen.

**Why this priority**: Notifications are cross-cutting infrastructure needed by multiple
feature modules (rides, maintenance, group events). Core FCM setup must be complete
before feature modules can send or receive notifications.

**Independent Test**: Send a test FCM notification to the device token and confirm
it appears in the foreground and navigates to the correct route on tap.

**Acceptance Scenarios**:

1. **Given** the app launches for the first time, **When** FCM permission is requested,
   **Then** the device FCM token is retrieved and stored locally in secure storage.
   When the user subsequently logs in successfully, the token is uploaded to the
   `users.fcm_token` field in Supabase.

2. **Given** the app is in the foreground, **When** a push notification arrives,
   **Then** it is displayed as an in-app notification banner with the correct title
   and body.

3. **Given** the rider taps a notification of type `ride_started` with a `ride_id`,
   **When** the notification handler processes it, **Then** the app navigates to the
   live map screen for that ride using the GoRouter named route.

---

### Edge Cases

- ~~What happens when the Supabase initialization fails on app start?~~ **Resolved**: The app shows a full-screen no-connection screen with a Retry button. No feature content is accessible until Supabase initializes successfully.
- How does the AI service behave when the Edge Function proxy returns a 5xx error after 2 retries?
- What happens when a notification arrives with an unrecognized `type` field?
- ~~How does GoRouter handle a deep link (`motoorbito://join/{code}`) when the user is not authenticated?~~ **Resolved**: The deep link intent is stored locally; the user is redirected to auth, and the intent is processed automatically after successful login.
- ~~What happens if the FCM token refresh fires before the user has logged in?~~ **Resolved**: The refreshed token is stored locally in secure storage and uploaded to Supabase `users.fcm_token` at the next successful login.
- How does the storage service behave when a file exceeds 5MB?
- ~~What happens when `dart run slang` is run with missing translation keys in one locale?~~ **Resolved**: `dart run slang` MUST exit with an error if any key present in the primary (`ar.json`) locale is absent from any secondary locale (`en.json`). This is a build blocker — no fallback at runtime.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The system MUST provide two independently runnable app flavors —
  `development` (connects to `moto-orbito-dev` Supabase, logging active) and
  `production` (connects to `moto-orbito` Supabase, logging silent).

- **FR-002**: The system MUST expose a unified error-result type that wraps all
  cross-layer responses; raw exceptions MUST NOT cross layer boundaries. If Supabase
  fails to initialize at app launch (e.g., no network), the app MUST display a
  full-screen no-connection screen with a Retry button and MUST NOT proceed to the
  main shell until initialization succeeds.

- **FR-003**: The system MUST provide a centralized dependency injection container
  that registers all core services, and all future feature modules MUST register
  their dependencies through per-feature DI modules.

- **FR-004**: The system MUST provide type-safe, named navigation routes for all
  screens defined in the project navigation map, with an authentication guard that
  redirects unauthenticated users to the welcome screen. If an unauthenticated user
  triggers a deep link (e.g., a group invite), the system MUST store the deep link
  intent locally, redirect to auth, and process the intent automatically upon
  successful login.

- **FR-005**: The system MUST expose a single HTTP client abstraction that intercepts
  every request to attach auth tokens, log activity, and map HTTP errors to typed
  failure objects — direct HTTP library usage is forbidden everywhere else.

- **FR-006**: The system MUST provide a Supabase service layer covering database
  access, realtime channel management (subscribe/broadcast/unsubscribe per ride),
  and file storage (upload, delete, 5MB limit enforcement).

- **FR-007**: The system MUST initialize Firebase Cloud Messaging, request permissions,
  manage token lifecycle, display foreground notifications, and navigate to the correct
  screen on notification tap based on the notification type and target identifier fields.
  FCM tokens obtained before authentication MUST be stored locally in secure storage
  and uploaded to the user's profile in Supabase immediately upon successful login.
  Token refreshes occurring before login MUST follow the same local-storage pattern.

- **FR-008**: The system MUST provide an AI service that proxies all AI calls through
  a Supabase Edge Function (never directly to an AI provider), with a 30-second
  timeout, maximum 2 retries, and all prompt templates stored as constants.

- **FR-009**: The system MUST provide a complete theme system with brand colors,
  typography, and spacing — all accessed exclusively through theme extensions —
  supporting both light and dark modes from day one.

- **FR-010**: The system MUST provide a set of shared UI components (button, text
  field, loader, snack bar, skeleton, empty state, error state, offline state, bottom
  navigation) that are RTL-aware, theme-aware, and fully localized.

- **FR-011**: The system MUST provide a localization layer with Arabic as the primary
  language and English as the secondary; all user-visible strings MUST be sourced from
  locale files, never hardcoded. The `dart run slang` command MUST fail with an error
  if any key present in `ar.json` (the source of truth) is absent from `en.json`;
  incomplete secondary locale files are a build blocker with no runtime fallback.

- **FR-012**: The system MUST provide a structured logging utility that is active
  only in the development flavor, never logs sensitive data (passwords, tokens,
  blood type, emergency contacts), and causes a static analysis warning for any
  direct `print()` usage.

### Non-Functional Constraints *(Moto Orbito — derived from constitution)*

These apply to every feature and do not need to be re-justified per spec:

- **NF-001**: All state MUST be managed via Cubit/Bloc with `sealed class` states.
- **NF-002**: All cross-layer calls MUST return `ApiResult<T>`; UI MUST handle loading/success/empty/error.
- **NF-003**: All user-visible strings MUST use `slang` keys — no hardcoded text.
- **NF-004**: All colors and text styles MUST come from `ThemeData`/`AppColorsExtension`.
- **NF-005**: All Supabase access MUST reside in `data/repositories/` only.
- **NF-006**: Feature is incomplete without Unit + Cubit + Widget test coverage via `mocktail`.
- **NF-007**: Navigation MUST use `go_router` named routes; only primitive IDs passed.
- **NF-008**: No new packages without approval; `pubspec.yaml` not modified without explicit sign-off.

### Key Entities

- **ApiResult\<T\>**: Sealed class with `Success<T>` and `Failure<T>` subtypes — the
  universal cross-layer result envelope.
- **Failure**: Abstract base with 7 concrete subtypes (`NetworkFailure`, `ServerFailure`,
  `AuthFailure`, `NotFoundFailure`, `PermissionFailure`, `StorageFailure`,
  `UnexpectedFailure`), each carrying a raw localization string key. The UI layer
  is exclusively responsible for translating this key using `context.t`.
- **AppColorsExtension**: ThemeExtension holding all brand color tokens for both
  light and dark themes.
- **Route Constants**: Typed string constants for every screen in the app navigation
  map, used exclusively by the router.
- **Notification Payload**: Structured data containing `type` (e.g., `ride_started`)
  and `target_id` (e.g., a ride identifier) used to determine navigation on tap.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The app launches from a clean install in under 3 seconds on a mid-range
  Android device (development flavor).

- **SC-002**: Static analysis returns zero issues on the entire codebase after
  Phase 0 is complete.

- **SC-003**: All core layer unit tests pass with 100% success rate and no skipped tests.

- **SC-004**: Language switching between Arabic and English takes under 500ms with
  no visible flash or layout shift.

- **SC-005**: All 12 core subsystems (bootstrap, error handling, DI, navigation,
  networking, Supabase, FCM, AI, theming, shared widgets, localization, logging)
  are independently verifiable through automated tests or targeted manual steps.

- **SC-006**: Zero hardcoded strings, colors, or sizes exist in any file under
  the core layer — confirmed by static analysis and code review.

- **SC-007**: Every shared widget (button, text field, empty state, loader, snack bar)
  renders correctly in both light and dark mode, and in both left-to-right and
  right-to-left layout directions.

- **SC-008**: A deep link of the format `motoorbito://join/{invite_code}` is handled
  by the app when activated from outside the app, routing to the correct screen.

---

## Assumptions

- The Flutter project and its two Android flavors (`development`, `production`)
  already exist and are configured — no project initialization is needed.
- Both entry point files (`main_development.dart`, `main_production.dart`) already
  exist with their respective Supabase credentials and MUST NOT be modified unless
  explicitly instructed.
- All packages listed in the approved dependency list are pre-approved; no additional
  packages will be introduced during Phase 0.
- The Supabase projects (`moto-orbito-dev` and `moto-orbito`) are already provisioned
  with at least one test table available for connection verification.
- Firebase is already initialized in the project (platform service files are present
  in the repository).
- The AI service communicates with a Supabase Edge Function proxy; the Edge Function
  URL will be provided as a configuration value in the entry point files.
- Arabic locale files are the source of truth; English locale files must maintain
  identical key structure.
- `AppLogger` behavior is controlled by flavor — no runtime toggle or user setting
  is required.
- Phase 0 has no dependency on any external user-facing data; all acceptance
  verification can be done with test data or mock values.
