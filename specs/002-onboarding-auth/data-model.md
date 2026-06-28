# Data Model: Onboarding & Authentication (Phase 1)

**Date**: 2026-06-28
**Feature**: [spec.md](spec.md) | **Plan**: [plan.md](plan.md)

---

## Supabase Tables

### `users`

Stores the extended rider profile linked to Supabase Auth.

| Column | Type | Nullable | Constraints | Description |
|--------|------|----------|-------------|-------------|
| `id` | `uuid` | No | PK, FK → `auth.users.id` ON DELETE CASCADE | Matches Supabase auth UID |
| `full_name` | `text` | No | NOT NULL | Rider display name from sign-up or OAuth |
| `email` | `text` | No | NOT NULL, UNIQUE | Email address (mirrors auth.users.email) |
| `phone` | `text` | Yes | — | Phone number including country code |
| `phone_verified_at` | `timestamptz` | Yes | — | NULL = pending; non-null = verified |
| `profile_photo_url` | `text` | Yes | — | Supabase Storage URL; populated from OAuth if available |
| `fcm_token` | `text` | Yes | — | Current device FCM token; cleared on sign-out |
| `locale` | `text` | No | DEFAULT `'ar'` | User language preference (`ar` or `en`) |
| `is_onboarding_complete` | `boolean` | No | DEFAULT `false` | Server-side onboarding flag (not used for routing; local flag takes precedence) |
| `created_at` | `timestamptz` | No | DEFAULT `now()` | Account creation timestamp |
| `updated_at` | `timestamptz` | No | DEFAULT `now()` | Auto-updated on row change |

**RLS Policies** (must be set in Supabase dashboard):
- `SELECT`: authenticated users can read only their own row (`id = auth.uid()`).
- `INSERT`: allowed for service role only (inserted by Edge Function or trigger on auth.users creation).
- `UPDATE`: authenticated users can update only their own row.
- `DELETE`: service role only (account deletion Edge Function).

**Trigger**: `on_auth_user_created` — Supabase DB trigger that inserts a minimal `users` row on `auth.users` INSERT, pre-filling `id`, `email`, and `full_name` (from raw_user_meta_data for OAuth users).

---

## Dart Entities (Domain Layer)

### `UserEntity`

**File**: `lib/features/auth/domain/entities/user_entity.dart`

| Field | Type | Description |
|-------|------|-------------|
| `id` | `String` | UUID — matches Supabase auth UID |
| `email` | `String` | Verified email address |
| `fullName` | `String` | Rider display name |
| `phone` | `String?` | Phone number; null if not provided |
| `isEmailVerified` | `bool` | Derived from `auth.users.email_confirmed_at != null` |
| `isPhoneVerified` | `bool` | Derived from `users.phone_verified_at != null` |
| `fcmToken` | `String?` | Current FCM token; used to detect stale registrations |
| `locale` | `String` | `'ar'` or `'en'` |
| `createdAt` | `DateTime` | Account creation timestamp |

**Rules**:
- `UserEntity` is immutable (no setters).
- Equality based on `id` only.
- Never passed between screens — only `id` (String) is passed via navigation.

---

## Dart DTOs (Data Layer)

### `AuthUserModel`

**File**: `lib/features/auth/data/models/auth_user_model.dart`

Maps the JSON response from Supabase Auth session + `users` table row.

| Field | Type | Source |
|-------|------|--------|
| `id` | `String` | `session.user.id` |
| `email` | `String` | `session.user.email` |
| `emailConfirmedAt` | `String?` | `session.user.emailConfirmedAt` |
| `fullName` | `String` | `users.full_name` |
| `phone` | `String?` | `users.phone` |
| `phoneVerifiedAt` | `String?` | `users.phone_verified_at` |
| `fcmToken` | `String?` | `users.fcm_token` |
| `locale` | `String` | `users.locale` |
| `createdAt` | `String` | `users.created_at` |

### `SignUpRequestModel`

**File**: `lib/features/auth/data/models/sign_up_request_model.dart`

| Field | Type | Validation |
|-------|------|------------|
| `email` | `String` | Valid email format, non-empty |
| `password` | `String` | Min 8 characters |
| `fullName` | `String` | Non-empty |
| `phone` | `String` | Valid phone format with country code |

### `LoginRequestModel`

**File**: `lib/features/auth/data/models/login_request_model.dart`

| Field | Type | Validation |
|-------|------|------------|
| `email` | `String` | Valid email format, non-empty |
| `password` | `String` | Non-empty |

---

## Dart Mappers (Data Layer)

### `AuthUserMapper`

**File**: `lib/features/auth/data/mappers/auth_user_mapper.dart`

| Method | Input | Output |
|--------|-------|--------|
| `toEntity(model)` | `AuthUserModel` | `UserEntity` |

Rules:
- `isEmailVerified` = `model.emailConfirmedAt != null`
- `isPhoneVerified` = `model.phoneVerifiedAt != null`
- `createdAt` = `DateTime.parse(model.createdAt)`
- Never called outside the `data/` layer.

---

## Local Storage Keys

Stored in `flutter_secure_storage`:

| Key | Type | Description |
|-----|------|-------------|
| `onboarding_seen` | `String ('true'/'false')` | Whether the user has completed onboarding on this device |
| `user_locale` | `String ('ar'/'en')` | Cached locale preference (fallback: `'ar'`) |

---

## Cubit States (Presentation Layer)

### `AuthState` (sealed)

```
AuthInitial
AuthLoading
AuthAuthenticated { UserEntity user }
AuthUnauthenticated
AuthError { String messageKey }
```

### `OnboardingState` (sealed)

```
OnboardingInitial
OnboardingInProgress { int currentPage }
OnboardingComplete
```

### `SignUpState` (sealed)

```
SignUpInitial
SignUpLoading
SignUpSuccess
SignUpError { String messageKey }
```

### `LoginState` (sealed)

```
LoginInitial
LoginLoading
LoginSuccess { UserEntity user }
LoginError { String messageKey }
```

### `OtpState` (sealed)

```
OtpInitial
OtpSending
OtpSent { int resendCountdownSeconds; int resendAttemptsRemaining }
OtpVerifying
OtpVerified
OtpError { String messageKey }
OtpResendExhausted
```

---

## State Transition Flows

### New User (Email Path)
```
SplashScreen (OnboardingInitial)
  → checkIfSeen() → false
  → OnboardingInProgress
  → OnboardingComplete
  → SignUpScreen (SignUpInitial)
  → SignUpLoading → SignUpSuccess
  → EmailVerificationScreen (OtpInitial → OtpSent)
  → OtpVerified
  → PhoneOtpEnterScreen (optional — OtpInitial)
    → skip → ProfileSetup
    → OtpVerified → ProfileSetup
```

### Returning User (Auto-Login)
```
SplashScreen
  → AuthCubit.checkSession()
  → AuthAuthenticated
  → GoRouter redirect → /home
```

### Social Sign-In (First Time)
```
WelcomeScreen
  → signInWithGoogle()
  → AuthLoading → AuthAuthenticated (first-time flag detected)
  → ProfileSetup
```

### Social Sign-In (Returning)
```
WelcomeScreen
  → signInWithGoogle()
  → AuthLoading → AuthAuthenticated (returning)
  → GoRouter redirect → /home
```
