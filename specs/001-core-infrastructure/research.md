# Research: Project Foundation & Core Infrastructure (Phase 0)

**Date**: 2026-06-28
**Feature**: [spec.md](spec.md) | **Plan**: [plan.md](plan.md)

All decisions below are resolved from Flutter 2026 best practices, the pre-approved package
list, and the clarifications captured in the spec. No unknowns remain.

---

## Decision 1: ApiResult<T> Implementation Pattern

**Decision**: Dart 3 native sealed class with two subtypes — `Success<T>` and `Failure`.

```dart
// lib/core/error/api_result.dart
sealed class ApiResult<T> {
  const ApiResult();
}

final class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends ApiResult<T> {
  final AppFailure failure;
  const Failure(this.failure);
}
```

**Rationale**: Dart 3 sealed classes give exhaustive `switch` enforcement at compile time,
matching the constitution's requirement without Freezed or code generation.

**Alternatives Considered**:
- `Either<L, R>` (functional style via `dartz`) — rejected: adds unapproved package, less
  idiomatic in Flutter 2026.
- Nullable returns — rejected: constitution explicitly forbids nullables at layer boundaries.

---

## Decision 2: Failure Hierarchy

**Decision**: Abstract `AppFailure` base class with a `messageKey` (raw `slang` key string)
and 7 concrete subtypes. UI layer translates `messageKey` via `context.t`.

```dart
abstract class AppFailure {
  final String messageKey; // e.g., 'errors.network'
  const AppFailure(this.messageKey);
}

class NetworkFailure extends AppFailure { const NetworkFailure() : super('errors.network'); }
class ServerFailure extends AppFailure {
  final int? statusCode;
  const ServerFailure({this.statusCode}) : super('errors.server');
}
class AuthFailure extends AppFailure { const AuthFailure() : super('errors.auth'); }
class NotFoundFailure extends AppFailure { const NotFoundFailure() : super('errors.notFound'); }
class PermissionFailure extends AppFailure { const PermissionFailure() : super('errors.permission'); }
class StorageFailure extends AppFailure { const StorageFailure() : super('errors.storage'); }
class UnexpectedFailure extends AppFailure { const UnexpectedFailure() : super('errors.unexpected'); }
```

**Rationale**: Clarification Q5 resolved that `Failure` stores raw keys; UI translates.
This keeps Domain and Data layers entirely free of `BuildContext` and `slang` imports.

**Alternatives Considered**:
- Storing pre-translated strings inside `Failure` — rejected: requires passing translation
  context into the data layer, violating layer boundaries.
- UI `switch` on failure type only — rejected: requires UI knowledge of all subtypes;
  raw key is simpler and more extensible.

---

## Decision 3: GetIt DI Bootstrap Strategy

**Decision**: Single `initDependencies()` async function in `injection_container.dart`
called from each entry point before `runApp()`. Each subsystem in `core/` registers
via a `coreModule()` function. Feature modules will register via their own `featureModule()`
functions (called from `injection_container.dart` in Phase 1).

**Rationale**: This is the standard get_it pattern for Flutter apps. The single init function
is the natural extension point — adding a Phase 1 feature module requires one line.

**Alternatives Considered**:
- Auto-discovery via annotations — rejected: requires `injectable` package (not approved).
- Registering everything flat in one file — rejected: grows unmaintainable at 10+ modules.

---

## Decision 4: GoRouter Auth Guard & Deep Link Intent

**Decision**: GoRouter `redirect` callback checks Supabase session state. If a user
arrives at a protected route unauthenticated, the pending route URI is serialized and
stored in `flutter_secure_storage` under key `pending_deep_link`. After login, the auth
success handler reads and clears `pending_deep_link`, then navigates via `context.go()`.

**Rationale**: Clarification Q4 resolved this pattern. Using `flutter_secure_storage` for
intent storage is consistent with the existing pre-auth FCM token storage (Q2 resolution).
GoRouter's `redirect` function is the correct place to intercept unauthenticated access.

**Alternatives Considered**:
- Passing intent through navigation stack — rejected: GoRouter redirect clears the stack,
  making pass-through impossible without extra scaffolding.
- Anonymous Supabase record for intent — rejected: over-engineered for a simple URI string.

---

## Decision 5: FCM Token Pre-Auth Storage

**Decision**: Clarification Q2 resolved: `FcmService` calls `getToken()` immediately
on app init. The token is stored in `flutter_secure_storage` under `fcm_token_pending`.
After a successful login, the auth repository (in Phase 1) reads `fcm_token_pending`,
uploads it to `users.fcm_token` in Supabase, and clears the local key.
`onTokenRefresh` follows the same local-store pattern.

**Rationale**: Zero data loss, no anonymous Supabase records, no FCM re-request after login.
`flutter_secure_storage` is already in the approved package list.

---

## Decision 6: AppLogger Flavor-Gating Strategy

**Decision**: `AppLogger` accepts a `bool enabled` flag injected at construction time.
Each entry point calls `AppLogger.init(enabled: true/false)` before `runApp()`. In
`main_production.dart`, `enabled: false` makes all log methods no-ops. No `kDebugMode`
used.

```dart
class AppLogger {
  static bool _enabled = false;
  static void init({required bool enabled}) => _enabled = enabled;
  static void debug(String msg) { if (_enabled) _log('DEBUG', msg); }
  static void info(String msg)  { if (_enabled) _log('INFO', msg); }
  static void warning(String msg) { if (_enabled) _log('WARN', msg); }
  static void error(String msg, {Object? error, StackTrace? stackTrace}) {
    if (_enabled) _log('ERROR', msg, error: error, stackTrace: stackTrace);
  }
  static void _log(String level, String msg, {Object? error, StackTrace? stackTrace}) { ... }
}
```

**Rationale**: Constitution §Architecture Constraints — Flavors explicitly states no
`kDebugMode`/`kReleaseMode` as flavor proxy. The `init()` call in entry points is the
idiomatic alternative; it's also easily testable.

---

## Decision 7: slang Strict Parity Mode

**Decision**: Configure `slang` with `fallback_strategy: none` in `slang.yaml`. This
causes `dart run slang` to fail with an error if any key is present in `ar.json` but
absent from `en.json`.

```yaml
# slang.yaml
base_locale: ar
fallback_strategy: none
input_directory: assets/i18n
input_file_pattern: .json
output_directory: lib/core/i18n
```

**Rationale**: Clarification Q3 resolved this. `fallback_strategy: none` is the
`slang` package's built-in mechanism for enforcing locale key parity at build time.

---

## Decision 8: ThemeExtension Registration Pattern

**Decision**: `AppColorsExtension` registered inside the `ThemeData` factory functions
in `app_theme.dart`. Access via `Theme.of(context).extension<AppColorsExtension>()!`.
A `BuildContext` extension `context.colors` provides the ergonomic shorthand.

**Rationale**: Native Flutter `ThemeExtension` approach — no extra packages. The `!`
non-null assertion is safe because the extension is always registered in both light and
dark themes.

---

## Decision 9: Supabase Initialization Failure Handling

**Decision**: Clarification Q1 resolved: wrap `Supabase.initialize(...)` in a try/catch
in `injection_container.dart`. If initialization fails, the app still runs but a flag
`supabaseInitialized = false` is stored in `InjectionContainer`. `AppRouter` checks this
flag and redirects to `/no-connection` screen if false. The `NoInternetScreen` has a
Retry button that calls `initDependencies()` again.

**Rationale**: The no-connection screen is already a mandated shared widget (FR-010).
Reusing it for Supabase init failure keeps the pattern consistent and avoids a native
crash dialog.

---

## Decision 10: flutter_screenutil Initialization

**Decision**: `ScreenUtil.init()` is called inside the `MaterialApp.builder` callback
(not at app root). Design base size: 390×844 (iPhone 14 equivalent, common reference).
`textScaleFactor` is fixed to prevent system text scale breaking layouts.

**Rationale**: Calling `ScreenUtil.init` in `builder` ensures it is initialized before
any child widget renders, avoids context issues, and is the pattern recommended by the
`flutter_screenutil` maintainers in 2026.

---

## Summary: All NEEDS CLARIFICATION Resolved

| Item | Resolution |
|------|------------|
| Supabase init failure | No-connection screen + retry (Q1) |
| FCM token pre-auth | Local secure storage → upload on login (Q2) |
| slang missing keys | Build failure via `fallback_strategy: none` (Q3) |
| Deep link unauthenticated | Store intent in secure storage, process after login (Q4) |
| Failure localization | Raw key stored; UI translates via `context.t` (Q5) |
| AppLogger flavor-gating | `init(enabled:)` from entry point; no `kDebugMode` |
| GoRouter deep link intent | `pending_deep_link` key in `flutter_secure_storage` |
| ThemeExtension access | `context.colors` extension on `BuildContext` |
| screenutil init | `MaterialApp.builder` callback |
