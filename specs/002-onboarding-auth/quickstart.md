# Quickstart: Onboarding & Authentication (Phase 1)

**Date**: 2026-06-28
**Feature**: [spec.md](spec.md) | **Plan**: [plan.md](plan.md)

This guide documents how to manually validate the critical paths of the Onboarding and Authentication flow during development.

---

## Prerequisites

1.  **Dependencies**: Run `flutter pub get`.
2.  **Code Generation**: Run `dart run build_runner build -d` (if any mappers/models need it, though Moto Orbito avoids build_runner for domain entities, it might be used for DI or JSON serialisation depending on Phase 0 setup). Run `dart run slang` to generate localization keys.
3.  **Supabase Config**: Ensure `.env` or entry point files contain valid dev Supabase URL and anon key.
4.  **Backend Services**: 
    -   Supabase Auth is enabled with Email and Password providers.
    -   Google and Facebook OAuth providers are configured in the Supabase dashboard.
    -   `users` table exists with RLS policies allowing insert via trigger/service role and select/update for the authenticated user.
    -   Edge Function `delete-account` is deployed.

---

## Scenario 1: New User Sign-Up & Email Verification

**Goal**: Verify a user can register, receive an OTP, verify their email, and reach the Profile Setup screen.

1.  **Launch the app** on an emulator/device.
2.  **Onboarding**: Swipe through the 3 onboarding screens and tap "Get Started".
    *   *Expected*: Navigates to Welcome Screen.
3.  **Sign Up**: Tap "Sign Up". Fill in realistic data (use a real email address you can access for the OTP).
4.  **Submit**: Tap "Create Account".
    *   *Expected*: Navigates to Email Verification Screen.
5.  **Check Email**: Retrieve the 6-digit OTP from the email sent by Supabase.
6.  **Verify**: Enter the 6-digit OTP into the app.
    *   *Expected*: Navigates to Phone Verification Screen (optional step).
7.  **Skip Phone**: Tap "Skip for Now".
    *   *Expected*: Navigates to Profile Setup Screen.

---

## Scenario 2: Unverified User Login Block

**Goal**: Verify that a user who has signed up but *not* verified their email cannot access the app.

1.  **Setup**: Perform steps 1-4 of Scenario 1 (create an account but do not enter the OTP). Force close the app.
2.  **Launch the app**.
    *   *Expected*: You are on the Welcome screen (no active valid session).
3.  **Login**: Tap "Log In". Enter the email and password you just created.
4.  **Submit**: Tap "Log In".
    *   *Expected*: Login is blocked. You are redirected to the Email Verification screen. The email field is pre-populated.

---

## Scenario 3: Social Sign-In (New User)

**Goal**: Verify that signing in with a Google account for the first time creates a user and routes to Profile Setup.

1.  **Start** on the Welcome screen.
2.  **Google Sign-In**: Tap "Continue with Google".
3.  **Consent**: Select a Google account in the native picker.
4.  **Complete**: Wait for the OAuth flow to finish.
    *   *Expected*: Navigates to the Profile Setup screen.
5.  **Database Check**: Open the Supabase dashboard. Verify a new row exists in `auth.users` and the `users` table for this user.

---

## Scenario 4: Returning User Auto-Login

**Goal**: Verify that a user with a valid session bypasses the auth flow on startup.

1.  **Setup**: Complete Scenario 1 or Scenario 3 so you are authenticated (and ideally have completed profile setup, but being past the auth screens is sufficient).
2.  **Force Close**: Kill the app from the task switcher.
3.  **Launch the app**.
    *   *Expected*: The splash screen shows briefly, then the app navigates directly to the Home screen (or Profile Setup if pending). It should **not** show the Welcome screen.

---

## Scenario 5: Account Deletion (Typing Confirmation)

**Goal**: Verify the irreversible account deletion flow and its safety mechanism.

1.  **Setup**: Be logged into the app (e.g., from Scenario 4).
2.  **Navigate**: Go to Settings -> Account -> Delete Account (mocked or actual navigation depending on phase completion).
3.  **Confirm Screen**: The Delete Account confirmation screen is shown.
4.  **Attempt early delete**: The "Delete" button should be disabled.
5.  **Type incorrect phrase**: Type "delete" (lowercase) or "YES".
    *   *Expected*: The "Delete" button remains disabled.
6.  **Type exact phrase**: Type "DELETE" (uppercase).
    *   *Expected*: The "Delete" button becomes enabled.
7.  **Execute**: Tap "Delete".
    *   *Expected*: The account is deleted, the session is cleared, and you are routed back to the Welcome screen. Logging in with those credentials again should fail.
