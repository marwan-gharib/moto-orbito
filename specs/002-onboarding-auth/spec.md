# Feature Specification: Onboarding & Authentication

**Feature Branch**: `002-onboarding-auth`

**Created**: 2026-06-28

**Status**: Draft

**Input**: User description: "PHASE 1 — Onboarding & Authentication"

---

## Clarifications

### Session 2026-06-28

- Q: Should an unverified user be allowed to log in before completing email verification? → A: Block login entirely; redirect the user to the Email Verification screen to complete OTP.
- Q: What form of confirmation must the user complete before account deletion is executed? → A: User must type a specific confirmation phrase (e.g., "DELETE") before the deletion button activates.
- Q: Should there be a maximum number of OTP resend attempts allowed per registration session? → A: Maximum 3 resend attempts per session; after the 3rd, show an error message and disable further resends until the user restarts the sign-up flow.
- Q: When is the phone OTP screen shown to the user in the Phase 1 sign-up flow? → A: Optional step shown after email verification — user can skip it and verify their phone later in Profile Setup.
- Q: Where should a brand-new social sign-in user be routed after OAuth completes? → A: Route to Profile Setup (same as email sign-up users) — ensures all riders complete the same baseline profile regardless of sign-in method.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - First-Time App Launch & Onboarding (Priority: P1)

A brand-new user downloads Moto Orbito and opens the app for the first time. They see an animated splash screen, then a 3-slide onboarding carousel that explains the app core value propositions: riding together in groups, AI-powered riding insights, and maintenance + safety tracking. They can page through the slides or skip directly. At the end, they tap "Get Started" and land on the Sign Up screen.

**Why this priority**: This is the very first user experience. If it fails or confuses, the user churns immediately before registering. It also gates the entire authentication flow.

**Independent Test**: Can be fully tested by clearing app data, launching the app, and verifying the splash to onboarding to sign-up flow end-to-end, delivering a clear app value proposition before any account creation.

**Acceptance Scenarios**:

1. **Given** the app is freshly installed and opened, **When** the splash screen appears, **Then** it displays the animated Moto Orbito logo for approximately 2.5 seconds before navigating automatically.
2. **Given** the splash screen has elapsed, **When** the app checks whether onboarding has been previously seen, **Then** it routes to the onboarding slides (first run) or directly to the Welcome screen (returning user).
3. **Given** the user is on slide 1 of onboarding, **When** they swipe forward or tap Next, **Then** they advance to slide 2.
4. **Given** the user is on any slide, **When** they tap Skip, **Then** they are taken directly to the Welcome screen without completing all slides.
5. **Given** the user is on slide 3 (the last slide), **When** they tap Get Started, **Then** onboarding is marked as complete and they are navigated to the Sign Up screen.
6. **Given** the user has previously completed onboarding, **When** they relaunch the app, **Then** the onboarding slides are NOT shown again.
7. **Given** Arabic locale is active, **When** the onboarding screen renders, **Then** all slides display in RTL layout with text, buttons, and page indicator aligned correctly.

---

### User Story 2 - New User Registration Email + Phone + Password (Priority: P1)

A new rider taps Sign Up on the Welcome screen and fills in their full name, email address, phone number (with country code), password, and confirms the password. After submitting, they receive a 6-digit OTP to their email. They enter the OTP in-app, it is verified, and are offered an optional phone verification step. They may verify their phone number now via a 6-digit SMS OTP, or skip this step and proceed directly to the Profile Setup screen. Phone verification can be completed later from Profile Settings.

**Why this priority**: Email registration is the primary account creation path. Without it, no user can access the app core features.

**Independent Test**: Can be fully tested by completing the sign-up form with valid data, receiving and entering the email OTP, and confirming arrival at the Profile Setup screen.

**Acceptance Scenarios**:

1. **Given** the Sign Up screen is visible, **When** the user leaves a required field empty and submits, **Then** an inline validation error appears on that field without navigating away.
2. **Given** the user enters an already-registered email, **When** they submit the sign-up form, **Then** an inline error indicates the email is already in use.
3. **Given** all fields are valid, **When** the user submits the form, **Then** a loading indicator replaces the submit button while the request is in progress.
4. **Given** sign-up succeeds, **When** the user is redirected to the Email Verification screen, **Then** the screen shows the email address and a 6-digit OTP input.
5. **Given** the user enters the correct 6-digit OTP, **When** the last digit is entered, **Then** the OTP is auto-submitted and verification begins immediately.
6. **Given** the OTP is verified successfully, **When** the verification completes, **Then** the user is navigated to the Profile Setup screen.
7. **Given** the user enters an incorrect OTP, **Then** an inline error is shown and the input is cleared for retry.
8. **Given** the user has not received the email, **When** 60 seconds have elapsed since the last send, **Then** the Resend Code button becomes active.
9. **Given** the user taps Resend Code before 60 seconds, **Then** the button remains disabled and a countdown timer is visible.
10. **Given** the user has exhausted all 3 resend attempts, **When** they attempt to resend again, **Then** the Resend Code button is permanently disabled for this session, an error message is shown instructing them to restart the sign-up flow, and no further OTP emails are sent.
11. **Given** email verification succeeds, **When** the phone OTP screen is presented, **Then** the user sees a prompt to verify their phone number with a "Verify Now" and a "Skip for Now" option.
12. **Given** the user taps "Skip for Now" on the phone OTP screen, **When** skipped, **Then** they are navigated directly to the Profile Setup screen with phone verification status marked as pending.
13. **Given** the user taps "Verify Now" and completes the SMS OTP successfully, **When** verification succeeds, **Then** their phone number is marked as verified and they are navigated to the Profile Setup screen.

---

### User Story 3 - Social Sign-In Google and Facebook (Priority: P1)

A user taps Continue with Google (or Facebook) on the Welcome or Login screen. They are taken through the platform native OAuth consent flow, and upon success are returned to the app as a fully authenticated user, landing on the Home Dashboard screen. If this is their first social sign-in, a user profile record is created automatically.

**Why this priority**: Social sign-in reduces registration friction significantly and is a key retention driver, especially for first-time users hesitant to fill in a full form.

**Independent Test**: Can be fully tested by tapping Continue with Google on a physical device, completing the Google consent, and confirming the user lands on the Home screen.

**Acceptance Scenarios**:

1. **Given** the user taps Continue with Google, **When** the native Google account picker appears, **Then** the user can select their Google account.
2. **Given** the user grants consent and this is their first time signing in with this social account, **When** the OAuth flow completes successfully, **Then** a profile record is created automatically and the user is navigated to the Profile Setup screen.
3. **Given** the user grants consent and they are a returning social sign-in user, **When** the OAuth flow completes successfully, **Then** they are authenticated and navigated directly to the Home screen.
4. **Given** the user cancels the Google OAuth flow, **When** they are returned to the app, **Then** they remain on the Welcome/Login screen with no error shown.
5. **Given** the OAuth provider returns an error, **When** the user is returned to the app, **Then** a friendly error message is shown (not a raw exception).
6. **Given** a social sign-in user has no existing profile, **When** sign-in succeeds, **Then** a profile record is created automatically with the data available from the provider (name, email, profile photo URL).
7. **Given** the same Google account is used again on a subsequent login, **When** sign-in completes, **Then** the existing user is authenticated and routed to Home (no duplicate account created, no Profile Setup shown again).

---

### User Story 4 - Returning User Login (Priority: P1)

An existing user opens the app and sees the Welcome screen. They tap Login, enter their email and password, and are taken to the Home screen. If they have an active session from a previous run, the app skips the login screen entirely and takes them straight to Home.

**Why this priority**: Returning user login is the most-executed path in the app lifetime. Auto-login and friction-free re-entry are critical to daily retention.

**Independent Test**: Can be fully tested by logging in with valid credentials and verifying arrival at the Home screen, then closing and reopening the app to confirm auto-login.

**Acceptance Scenarios**:

1. **Given** the user enters correct email and password, **When** they submit, **Then** they are authenticated and navigated to the Home screen.
2. **Given** the user enters a wrong password, **When** they submit, **Then** an error message is displayed inline without exposing raw error details.
3. **Given** the user enters an email not registered, **When** they submit, **Then** a user-friendly error indicates the account was not found.
4. **Given** an existing valid session is present on app launch, **When** the app starts, **Then** the user bypasses the Welcome/Login screens and lands directly on the Home screen.
5. **Given** a session has expired, **When** the app starts, **Then** the user is redirected to the Welcome screen.
6. **Given** a registered user with an unverified email attempts to log in with email and password, **When** the login request is submitted, **Then** login is blocked and the user is redirected to the Email Verification screen to complete OTP.

---

### User Story 5 - Password Recovery (Priority: P2)

A user who has forgotten their password taps Forgot Password on the Login screen, enters their email address, and receives a reset link. The screen shows a confirmation message. The user follows the link outside the app to reset their password.

**Why this priority**: Reduces support burden and prevents permanent user loss due to forgotten passwords. Less critical than the primary login/register flows but important for retention.

**Independent Test**: Can be fully tested by tapping Forgot Password, entering a registered email, and verifying the confirmation message appears in-app.

**Acceptance Scenarios**:

1. **Given** the user enters a registered email and taps Send Reset Link, **When** the request succeeds, **Then** a confirmation message is displayed on the same screen with no navigation.
2. **Given** the user enters an unregistered email, **When** the request is submitted, **Then** the confirmation message is still shown (to prevent user enumeration).
3. **Given** the request is in progress, **When** waiting for the server response, **Then** a loading indicator is visible and the button is disabled.

---

### User Story 6 - Sign Out and Account Deletion (Priority: P2)

An authenticated user can sign out from within the app. This clears their local session and push notification registration, returning them to the Welcome screen. Alternatively, a user can permanently delete their account, which removes all their data from the system.

**Why this priority**: Session management and account deletion are required for user trust and app store approval.

**Independent Test**: Can be tested by triggering sign-out and verifying the user returns to the Welcome screen with no active session, then re-launching the app to confirm no auto-login occurs.

**Acceptance Scenarios**:

1. **Given** an authenticated user triggers sign-out, **When** the sign-out completes, **Then** the local session is cleared, the FCM token is unregistered, and the user is navigated to the Welcome screen.
2. **Given** the user has signed out, **When** they relaunch the app, **Then** they are NOT auto-logged in and the Welcome screen is shown.
3. **Given** the user initiates account deletion, **When** the deletion confirmation screen appears, **Then** the user is required to type the exact phrase "DELETE" into a text field before the final delete button becomes active.
4. **Given** the user has typed "DELETE" and taps the confirm button, **When** the deletion request completes, **Then** their account is removed from the authentication system and all associated data is deleted.
5. **Given** account deletion completes, **When** the user is returned to the Welcome screen, **Then** any attempt to log in with the deleted credentials fails with an appropriate error.
6. **Given** the user types an incorrect or empty phrase into the confirmation field, **When** they attempt to submit, **Then** the delete button remains disabled and no deletion request is sent.

---

### Edge Cases

- What happens when the device loses internet connection during OTP verification?
  The system detects no connectivity before the call and shows an offline error state. The user can retry once connectivity is restored.
- What happens if the user force-closes the app mid-registration before OTP entry?
  On next launch, the user is returned to the Welcome screen. Partial sign-up state is not persisted.
- What happens if the OTP expires before the user enters it?
  The verification call returns an error; an inline message informs the user the code has expired and prompts them to request a new one.
- What happens if a social OAuth token returned from the provider is invalid?
  The data layer maps this to an AuthFailure; the UI shows a user-friendly error message.
- What happens when the user switches locale mid-flow?
  All screens re-render in the selected locale immediately; layout switches between RTL and LTR accordingly.
- What happens when a registered-but-unverified user tries to log in with email and password?
  Login is blocked. The system detects the unverified state and redirects the user directly to the Email Verification screen, preserving their registered email so they can complete OTP without re-entering it.
- What happens if the user types the wrong phrase on the account deletion confirmation screen?
  The delete button remains disabled. No network call is made. The user must clear and re-type the correct phrase before the action can proceed.
- What happens if the user exhausts all 3 OTP resend attempts?
  The Resend Code button is permanently disabled for the current session. A localized error message is displayed prompting the user to go back and restart the sign-up flow. No further OTP emails are sent.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display an animated splash screen on every app launch for approximately 2.5 seconds before routing to the appropriate next screen.
- **FR-002**: System MUST show onboarding slides (exactly 3) to first-time users only; subsequent launches MUST skip onboarding.
- **FR-003**: System MUST persist a flag locally indicating whether onboarding has been completed and MUST read this flag at startup.
- **FR-004**: Users MUST be able to skip onboarding from any slide and be taken directly to the Welcome screen.
- **FR-005**: Users MUST be able to create an account using full name, email address, phone number with country code, password, and password confirmation.
- **FR-006**: System MUST validate all Sign Up fields before submission: required fields, email format, phone format, minimum password length of 8 characters, and password confirmation match.
- **FR-007**: System MUST display inline validation errors on the affected field, not as snack bars or dialogs.
- **FR-008**: System MUST verify the user email address via a 6-digit OTP sent to the registered email after sign-up.
- **FR-009**: System MUST auto-submit the OTP as soon as all 6 digits are entered.
- **FR-010**: System MUST provide a Resend Code option that becomes active only after a 60-second cooldown has elapsed; the Resend Code action is limited to a maximum of 3 attempts per session. After the 3rd resend, the button MUST be permanently disabled and a localized message MUST inform the user to restart the sign-up flow.
- **FR-011**: System MUST support sign-in with Google OAuth on both iOS and Android.
- **FR-012**: System MUST support sign-in with Facebook OAuth on both iOS and Android.
- **FR-013**: System MUST allow users to log in with email and password.
- **FR-014**: System MUST automatically maintain the user authenticated session across app restarts without requiring re-login, as long as the session token is valid.
- **FR-015**: System MUST redirect unauthenticated users to the Welcome screen when they attempt to access any protected screen.
- **FR-016**: System MUST redirect already-authenticated users away from Welcome, Login, and Sign Up screens to the Home screen.
- **FR-017**: System MUST allow users to request a password reset email; the confirmation message MUST be displayed in-app regardless of whether the email exists.
- **FR-018**: System MUST allow users to sign out, clearing the local session and removing the FCM push notification token from the backend.
- **FR-019**: System MUST allow users to permanently delete their account; before executing deletion, the user MUST type the exact phrase "DELETE" into a confirmation field — the delete action MUST remain disabled until the phrase is matched exactly (case-sensitive). All associated data MUST be removed from the backend upon confirmation.
- **FR-020**: System MUST display a loading state during all async authentication operations.
- **FR-021**: System MUST map all authentication errors to user-friendly, localized messages; no raw error strings or exception details may be shown to the user.
- **FR-022**: System MUST check network connectivity before every authentication call and display an offline error state when no connection is available.
- **FR-023**: All onboarding screen text, buttons, and error messages MUST be fully localized in Arabic and English.
- **FR-024**: All authentication screen text, validation messages, and error messages MUST be fully localized in Arabic and English.
- **FR-025**: All onboarding and authentication screens MUST render correctly in RTL Arabic and LTR English layouts.
- **FR-026**: System MUST block email+password login for accounts with unverified email and redirect those users to the Email Verification screen, pre-populating their registered email address.
- **FR-027**: After successful email OTP verification, system MUST present the Phone Verification screen as an optional step; the screen MUST offer both a "Verify Now" path (SMS OTP flow) and a "Skip for Now" action. Skipping MUST mark phone verification as pending and navigate the user to the Profile Setup screen without blocking progress.
- **FR-028**: System MUST distinguish between first-time and returning social sign-in users; first-time social sign-in users MUST be routed to the Profile Setup screen after OAuth completes, while returning social sign-in users MUST be routed directly to the Home screen.

### Non-Functional Constraints *(Moto Orbito — derived from constitution)*

These apply to every feature and do not need to be re-justified per spec:

- **NF-001**: All state MUST be managed via Cubit/Bloc with `sealed class` states.
- **NF-002**: All cross-layer calls MUST return `ApiResult<T>`; UI MUST handle loading/success/empty/error.
- **NF-003**: All user-visible strings MUST use `slang` keys, no hardcoded text.
- **NF-004**: All colors and text styles MUST come from `ThemeData`/`AppColorsExtension`.
- **NF-005**: All Supabase access MUST reside in `data/repositories/` only.
- **NF-006**: Feature is incomplete without Unit + Cubit + Widget test coverage via `mocktail`.
- **NF-007**: Navigation MUST use `go_router` named routes; only primitive IDs passed.
- **NF-008**: No new packages without approval; `pubspec.yaml` not modified without explicit sign-off.

### Key Entities

- **User**: A registered rider account. Key attributes: unique identifier, full name, email address, phone number, email verification status, account creation timestamp.
- **Session**: An active authentication token binding a user to the current device. Governs auto-login and route guarding. Expires based on backend policy.
- **OtpRequest**: A pending one-time passcode associated with an email or phone, scoped to a single verification attempt. Has a limited validity window.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A new user can complete the full registration flow (sign-up to email OTP verification to Profile Setup) in under 3 minutes on a standard mobile connection.
- **SC-002**: A returning user with a valid session reaches the Home screen in under 2 seconds from app launch (splash screen included).
- **SC-003**: 95% of OTP emails are delivered and the verification code accepted within 2 minutes of request.
- **SC-004**: Google and Facebook OAuth flows complete successfully on both iOS and Android without crashing or leaving the user stranded.
- **SC-005**: 100% of authentication error states display user-friendly localized messages; zero raw exceptions surfaced to users.
- **SC-006**: All 25 functional requirements pass their acceptance scenarios in both Arabic RTL and English LTR layouts across both light and dark themes.
- **SC-007**: Onboarding is never shown more than once; zero users who have previously completed onboarding see it again on relaunch.
- **SC-008**: The resend OTP button is correctly disabled for the full 60-second cooldown period; zero early activations.
- **SC-009**: All Unit, Cubit, and Widget tests for this feature pass with zero failures.

---

## Assumptions

- Phase 0 (Core Infrastructure) is fully complete: GoRouter, GetIt DI, Supabase service, FCM service, ThemeData, slang localization, AppLogger, shared widgets, and `ApiResult<T>` are all operational before this feature is built.
- The Supabase backend projects are provisioned with the `auth.users` and `users` tables, with RLS enabled on the `users` table.
- Google Sign-In and Facebook Sign-In OAuth providers are configured in the Supabase dashboard for both dev and prod projects.
- The Google and Facebook developer app registrations (SHA-1 fingerprints, bundle IDs, app IDs) are already set up for both iOS and Android.
- Email OTP delivery is handled by Supabase Auth built-in email provider; no custom SMTP configuration is required for this phase.
- The password reset flow uses Supabase email-based reset link; the user follows the link in their email client outside the app to complete the reset. The in-app experience ends at the confirmation message.
- Account deletion is implemented via a Supabase Edge Function (for elevated privileges); the Flutter client calls this Edge Function with the authenticated user token.
- The Phone OTP screen is shown after email verification as an optional step in Phase 1. Phone verification completion is not required to proceed to Profile Setup; it can be completed from Profile Settings in Phase 2.
- The app primary language is Arabic; English is the secondary language. All new string keys must be present in both `ar.json` and `en.json`.
- Session persistence is managed automatically by the `supabase_flutter` package; no custom token refresh logic needs to be built for this phase.
