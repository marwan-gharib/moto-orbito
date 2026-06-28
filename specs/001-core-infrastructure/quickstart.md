# Quickstart Validation Guide: Core Infrastructure (Phase 0)

**Date**: 2026-06-28
**Feature**: [spec.md](spec.md)

---

## Prerequisites

1. Flutter SDK 3.32+ installed and on PATH
2. Android device or emulator connected (`flutter devices` shows it)
3. Both Supabase projects (`moto-orbito-dev`, `moto-orbito`) provisioned
4. Firebase `google-services.json` in `android/app/`
5. Dependencies installed: `flutter pub get`
6. Localization generated: `dart run slang`

---

## Scenario 1: App Launches in Development Flavor

**Validates**: SC-001 (< 3s launch), FR-001 (flavors), FR-003 (DI), FR-009 (theme)

```bash
flutter run --flavor development --target lib/main_development.dart
```

**Expected**:
- App launches in under 3 seconds
- Bottom navigation bar visible with 5 tabs (Dashboard, Groups, Live Map, Maintenance, Profile)
- UI renders in Arabic (RTL layout) by default
- Console shows `[DEBUG] AppLogger initialized — development flavor` log line
- No red error banners or exceptions in the console

---

## Scenario 2: No-Connection Screen on Supabase Init Failure

**Validates**: FR-002 (Supabase init failure handling), SC-005

1. Disconnect the device from Wi-Fi / mobile data
2. Launch the development flavor

**Expected**:
- App starts without crashing
- Full-screen no-connection screen is shown (not a blank screen or crash dialog)
- A Retry button is visible
- Tapping Retry re-attempts Supabase initialization
- After reconnecting to Wi-Fi and tapping Retry, the app proceeds to the normal bottom nav shell

---

## Scenario 3: Language Switch Arabic ↔ English

**Validates**: SC-004 (< 500ms switch), FR-011 (slang localization)

1. Launch development flavor (Arabic default)
2. Switch device language to English in system settings

**Expected**:
- App re-renders in English within 500ms
- No visible flash, blank screen, or layout shift
- All visible text is from locale files — no hardcoded strings visible

---

## Scenario 4: slang Build Fails on Missing Key

**Validates**: FR-011 (strict parity), Q3 clarification

1. Add a new key to `assets/i18n/ar.json` without adding it to `en.json`
2. Run `dart run slang`

**Expected**:
- Command exits with a non-zero status code and an error message listing the missing key
- No generated files are updated

After adding the same key to `en.json` and re-running `dart run slang`:
- Command succeeds and generated files are updated

---

## Scenario 5: GoRouter Auth Guard

**Validates**: FR-004 (auth guard), SC-008 (deep link)

1. Launch the app logged out
2. Attempt to navigate to a protected route directly (e.g., `/home`)

**Expected**:
- App redirects to the welcome screen
- The protected route is not rendered

**Deep link sub-test**:
1. While logged out, open `motoorbito://join/ABC123` from a browser or ADB:
   ```bash
   adb shell am start -W -a android.intent.action.VIEW -d "motoorbito://join/ABC123"
   ```
2. App opens and redirects to login
3. After completing login, app automatically navigates to the group join screen with code `ABC123`

---

## Scenario 6: FCM Token Stored Pre-Auth

**Validates**: FR-007 (FCM lifecycle), Q2 clarification

1. Launch the development flavor (not yet logged in)
2. Grant notification permissions when prompted
3. Check `flutter_secure_storage` for `fcm_token_pending` key via debug inspect

**Expected**:
- A non-empty FCM token string is stored under `fcm_token_pending`
- No Supabase write has occurred (user is not authenticated)

After completing login:
- `fcm_token_pending` is cleared from secure storage
- The `users` table in the development Supabase project has a non-null `fcm_token` for the test user

---

## Scenario 7: Shared Widgets in Both Themes + RTL/LTR

**Validates**: SC-007 (widgets in all combinations)

Run the widget test suite:
```bash
flutter test test/core/widgets/
```

**Expected**: All widget tests pass with 0 failures.

For manual verification — enable dark mode on device and re-run:
```bash
flutter run --flavor development --target lib/main_development.dart
```

Toggle theme and confirm `AppButton`, `AppTextField`, `EmptyStateWidget` all render correctly
in dark mode without any hardcoded color values.

---

## Scenario 8: Zero Analyzer Issues

**Validates**: SC-002 (`flutter analyze` clean), FR-012 (no print() usage)

```bash
flutter analyze
```

**Expected**: `No issues found!`

Confirm no `print()` calls exist:
```bash
grep -r "print(" lib/
```

**Expected**: No output (zero matches).

---

## Scenario 9: Full Test Suite

**Validates**: SC-003, NF-006 (test gate), constitution Test Gate

```bash
flutter test test/core/
```

**Expected**:
- All tests pass
- No skipped tests
- Coverage includes `api_result_test.dart`, `failure_test.dart`, `app_logger_test.dart`,
  `base_api_client_test.dart`, `app_router_test.dart`, `fcm_service_test.dart`,
  `app_button_test.dart`, `app_text_field_test.dart`, `empty_state_widget_test.dart`
