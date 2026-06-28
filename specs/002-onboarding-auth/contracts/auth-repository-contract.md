# Contract: AuthRepository

**Layer**: Domain → Data
**File**: `lib/features/auth/domain/repositories/auth_repository.dart`
**Implementation**: `lib/features/auth/data/repositories/auth_repository_impl.dart`

---

## Interface

All methods return `Future<ApiResult<T>>`. Every Supabase call is wrapped in
try/catch → Failure mapping. No raw exceptions leave the data layer.

| Method | Input | Output | Notes |
|--------|-------|--------|-------|
| `signUpWithEmailPassword(params)` | `SignUpParams` | `ApiResult<UserEntity>` | Creates auth user + inserts `users` row |
| `signInWithEmailPassword(params)` | `LoginParams` | `ApiResult<UserEntity>` | Detects unverified email after sign-in |
| `signInWithGoogle()` | — | `ApiResult<UserEntity>` | Native Google OAuth; detects first-time vs returning |
| `signInWithFacebook()` | — | `ApiResult<UserEntity>` | Native Facebook OAuth; detects first-time vs returning |
| `sendEmailOtp(params)` | `EmailParams` | `ApiResult<void>` | Triggers Supabase OTP email send |
| `verifyEmailOtp(params)` | `OtpVerifyParams` | `ApiResult<void>` | Verifies 6-digit OTP |
| `sendPhoneOtp(params)` | `PhoneParams` | `ApiResult<void>` | Triggers Supabase SMS OTP |
| `verifyPhoneOtp(params)` | `OtpVerifyParams` | `ApiResult<void>` | Verifies 6-digit SMS OTP |
| `sendPasswordResetEmail(params)` | `EmailParams` | `ApiResult<void>` | Sends reset link (always returns success to prevent enumeration) |
| `signOut()` | — | `ApiResult<void>` | Clears session + sets `fcm_token = null` in `users` |
| `deleteAccount()` | — | `ApiResult<void>` | Calls Edge Function `delete-account` with user JWT |
| `getSession()` | — | `ApiResult<UserEntity?>` | Returns current session user or null |
| `isFirstTimeUser(uid)` | `String uid` | `Future<bool>` | Checks if `users` row exists for this uid |

---

## Params Classes

### `SignUpParams`
| Field | Type |
|-------|------|
| `email` | `String` |
| `password` | `String` |
| `fullName` | `String` |
| `phone` | `String` |

### `LoginParams`
| Field | Type |
|-------|------|
| `email` | `String` |
| `password` | `String` |

### `EmailParams`
| Field | Type |
|-------|------|
| `email` | `String` |

### `PhoneParams`
| Field | Type |
|-------|------|
| `phone` | `String` |

### `OtpVerifyParams`
| Field | Type | Description |
|-------|------|-------------|
| `target` | `String` | Email or phone number |
| `token` | `String` | 6-digit OTP code |
| `type` | `OtpType` | `email` or `sms` |

---

## Failure Mapping

| Supabase Error | Mapped To |
|----------------|-----------|
| `AuthException` (invalid credentials) | `AuthFailure` |
| `AuthException` (email already registered) | `AuthFailure` (with key `auth.emailAlreadyExists`) |
| `AuthException` (invalid OTP) | `AuthFailure` (with key `auth.invalidOtp`) |
| `AuthException` (OTP expired) | `AuthFailure` (with key `auth.otpExpired`) |
| No internet / timeout | `NetworkFailure` |
| Edge Function non-2xx | `ServerFailure` |
| Unknown exception | `UnexpectedFailure` |

---

## Unverified User Detection (signInWithEmailPassword)

```
1. Call supabase.auth.signInWithPassword(email, password)
2. If success:
   a. If session.user.emailConfirmedAt == null:
      → sign out immediately
      → return Failure(AuthFailure, messageKey: 'auth.emailNotVerified')
   b. Else: fetch users row, map to UserEntity, return Success
3. If AuthException: map to AuthFailure, return Failure
```

---

## First-Time Social User Detection (signInWithGoogle / signInWithFacebook)

```
1. Trigger native OAuth flow
2. On success: extract session.user.id
3. Query: SELECT id FROM users WHERE id = uid LIMIT 1
4. If no row → first-time user (isFirstTimeUser = true)
5. If row exists → returning user (isFirstTimeUser = false)
6. Map session + users row to UserEntity; attach isFirstTimeUser flag via UserEntity.isFirstTimeUser
7. Return ApiResult<UserEntity>
```

> Note: `UserEntity.isFirstTimeUser` is a transient field — not stored in the DB. Used only for routing decision in `AuthCubit`.
