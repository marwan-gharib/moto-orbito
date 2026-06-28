# Research: Onboarding & Authentication (Phase 1)

**Date**: 2026-06-28
**Feature**: [spec.md](spec.md) | **Plan**: [plan.md](plan.md)

---

## 1. Supabase Auth — OTP & Email Verification

### Decision
Use Supabase Auth built-in OTP (signUp + signInWithOtp) for email verification.
No custom SMTP required in Phase 1; Supabase default email provider handles delivery.

### Rationale
- `supabase_flutter` package already in the approved dependency list.
- Supabase Auth handles OTP generation, delivery, and expiry server-side.
- `supabase.auth.verifyOTP(email, token, type: OtpType.email)` is the single call for verification.
- Email OTP tokens expire after 1 hour by default (configurable in Supabase dashboard).

### Unverified User Detection
- `supabase.auth.signInWithPassword()` succeeds even for unverified users in Supabase by default.
- Detection strategy: after sign-in, check `session.user.emailConfirmedAt == null`.
- If null → sign the user out immediately, redirect to EmailVerificationScreen with pre-populated email.
- This pattern requires no custom Supabase configuration.

### OTP Resend Cap (3 Attempts)
- Supabase has server-side rate limiting (configurable per project dashboard).
- Client enforces the 3-resend cap as UI state in `OtpCubit` — counter persisted in-memory only (no local storage needed; session ends on app restart).
- After 3 client-side resends, the button is permanently disabled for the session.

### Alternatives Considered
- Custom SMTP for email delivery: deferred; unnecessary for Phase 1.
- Magic link login: out of scope; adds complexity without user request.

---

## 2. Google & Facebook OAuth via Supabase

### Decision
Use `supabase.auth.signInWithOAuth(OAuthProvider.google)` / `OAuthProvider.facebook`
with native handling via `google_sign_in` and `flutter_facebook_auth` packages.

### Rationale
- Both packages are on the pre-approved list (AGENTS.md §18).
- `supabase_flutter` handles token exchange after native OAuth completes.
- `google_sign_in` provides the native account picker sheet on iOS/Android.
- `flutter_facebook_auth` provides the native Facebook Login dialog.
- No custom OAuth redirect URIs needed beyond what Supabase sets up.

### First-Time vs Returning Social User Detection
- Strategy: after OAuth completes, check whether the `users` table row exists for the returned `uid`.
- If NO row exists → first-time user → insert row → route to ProfileSetup.
- If row exists → returning user → route to Home.
- This check lives in `AuthRepositoryImpl.signInWithGoogle/Facebook()`.

### Alternatives Considered
- Using Supabase OAuth web flow (in-app browser): rejected — native flows provide better UX and are required for iOS App Store review.
- Checking `session.user.createdAt` proximity: fragile; row-existence check is definitive.

---

## 3. Session Persistence & Auto-Login

### Decision
Rely on `supabase_flutter` built-in session persistence (SharedPreferences-backed by default).
JWT stored securely via `flutter_secure_storage` as an additional layer per AGENTS.md §16.

### Rationale
- `supabase_flutter` restores session on `Supabase.initialize()` call.
- `GoRouter` redirect reads `GetSessionUseCase` result to gate protected routes.
- On app launch: `AuthCubit.checkSession()` → emits `AuthAuthenticated` or `AuthUnauthenticated`.
- The GoRouter redirect fires synchronously after `AuthCubit` emits, preventing flash of login screen.

### Token Refresh
- Handled automatically by `supabase_flutter`; no manual refresh logic needed.

### Alternatives Considered
- Manual JWT storage only: adds complexity; Supabase's persistence is sufficient and tested.
- `SharedPreferences` for JWT: rejected per AGENTS.md §16 (must use `flutter_secure_storage`).

---

## 4. Account Deletion via Edge Function

### Decision
Account deletion is triggered by calling a Supabase Edge Function (`delete-account`)
authenticated with the user's JWT. The Edge Function uses the `service_role` key
to hard-delete the `auth.users` row and cascade-delete all user data.

### Rationale
- Flutter client uses `anon` key only — cannot call `supabase.auth.admin.deleteUser()` directly.
- Edge Function receives the caller's JWT, extracts `uid`, and performs deletion with elevated privileges.
- Client-side `DELETE` typing confirmation (phrase "DELETE") is enforced in `AuthCubit` before calling the use case.
- `DeleteAccountUseCase` calls `AuthRepository.deleteAccount()` which calls `BaseApiClient.post()` to the Edge Function URL.

### Alternatives Considered
- Supabase RLS + direct delete: insufficient — `auth.users` row requires service-role access.
- In-app admin SDK: rejected per security rules (service_role key must never be in Flutter code).

---

## 5. Phone OTP (Optional Step)

### Decision
Phone OTP uses `supabase.auth.signInWithOtp(phone: phone)` for SMS delivery.
The screen appears after email OTP verification. "Skip for Now" sets a local flag
`phone_verification_pending = true` which is passed to ProfileSetup.

### Rationale
- Supabase supports phone OTP natively (Twilio integration configured in dashboard).
- "Skip for Now" does not call any API — purely a navigation decision in `OtpCubit`.
- Phone verification status is tracked on the `users` table field `phone_verified_at` (nullable).
- A null `phone_verified_at` means pending; Profile Setup (Phase 2) can prompt completion.

### Alternatives Considered
- Making phone OTP mandatory: rejected — increases sign-up drop-off; deferred to Phase 2.
- Storing skip flag in secure storage: unnecessary; the `users.phone_verified_at` field is the source of truth.

---

## 6. Onboarding State Persistence

### Decision
Onboarding completion flag stored in `flutter_secure_storage` under key `onboarding_seen`.

### Rationale
- `flutter_secure_storage` is already required for JWT tokens.
- No need for a separate `SharedPreferences` dependency.
- `CheckOnboardingCompleteUseCase` reads this key; `MarkOnboardingCompleteUseCase` writes it.
- Both use cases operate on `OnboardingLocalRepository` (no network involved).

### Alternatives Considered
- `SharedPreferences`: rejected; project standard mandates `flutter_secure_storage` for all local persistence.
- Supabase `users` table field: overkill for a purely device-local flag.

---

## 7. GoRouter Auth Guard Pattern

### Decision
Single top-level `redirect` on `GoRouter` reads `AuthCubit` state injected via `GetIt`.
- If `AuthUnauthenticated` → redirect to `/welcome` (unless already there).
- If `AuthAuthenticated` + destination is `/welcome`/`/login`/`/sign-up` → redirect to `/home`.
- Splash and onboarding routes are exempt from the auth guard.

### Rationale
- This pattern is idiomatic for `go_router` + `flutter_bloc`.
- `GoRouter.refresh(listenable)` connected to `AuthCubit.stream` triggers re-evaluation on state change.
- Avoids race conditions: splash calls `AuthCubit.checkSession()`, which emits before GoRouter evaluates.

### Alternatives Considered
- Per-route guards: verbose and error-prone across 35+ routes; single top-level redirect is cleaner.
- `BlocListener` in a wrapper widget: rejected — navigation from widget layer violates AGENTS.md §19.

---

## 8. Cubit Scope & Lifecycle

### Decision
- `AuthCubit`: global, registered as `singleton` in GetIt, provided at `MaterialApp` root. Survives all navigation.
- `SignUpCubit`, `LoginCubit`, `OtpCubit`: registered as `factory`, scoped to their screen via `BlocProvider`.
- `OnboardingCubit`: registered as `factory`, scoped to onboarding flow.

### Rationale
- `AuthCubit` must be accessible from GoRouter redirect (not inside widget tree), so GetIt singleton is required.
- Form cubits are ephemeral — should reset on screen disposal. Factory registration ensures a fresh instance per navigation.

### Alternatives Considered
- Providing `AuthCubit` only at widget tree root: insufficient — GoRouter redirect needs it before the tree builds.

---

## 9. Localization Keys — Auth Namespace

All new keys added to `assets/i18n/ar.json` and `assets/i18n/en.json` under `auth.*` and `onboarding.*` namespaces.
`dart run slang` must be run after all keys are added.

New top-level namespaces for this feature:
- `onboarding.*` — slide titles, descriptions, buttons
- `auth.*` — form labels, validation messages, error messages, confirmation phrases
- `auth.deleteAccount.confirmPhrase` — the literal string "DELETE" (localized so it reads naturally in Arabic if needed)

> **Note**: The "DELETE" confirmation phrase for account deletion should be considered for localization. In Arabic, the equivalent would be used. This is flagged for the implementation phase.
