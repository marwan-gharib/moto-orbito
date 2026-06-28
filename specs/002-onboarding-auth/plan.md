# Implementation Plan: Onboarding & Authentication

**Branch**: `002-onboarding-auth` | **Date**: 2026-06-28 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/002-onboarding-auth/spec.md`

## Summary

This feature implements the complete onboarding and authentication flows for Moto Orbito. It covers new user sign-up with email and optional phone OTP verification, returning user auto-login, social sign-in (Google/Facebook), password reset, and account deletion. The architecture strictly follows the feature-first Clean Architecture pattern with Cubit for state management and `ApiResult<T>` for error handling. It leverages Supabase Auth for backend services and `go_router` for navigation guarding.

## Technical Context

**Language/Version**: Dart 3+, Flutter

**Primary Dependencies**: `flutter_bloc`, `get_it`, `go_router`, `dio`, `supabase_flutter`, `google_sign_in`, `flutter_facebook_auth`, `flutter_secure_storage`, `slang`

**Storage**: Supabase (PostgreSQL `users` table, `auth.users`), `flutter_secure_storage` for tokens and local flags

**Testing**: `mocktail`, Unit + Cubit + Widget tests

**Target Platform**: iOS & Android

**Project Type**: Mobile App

**Performance Goals**: < 3 mins for full sign up, < 2 secs to reach Home for returning users, < 2 mins for OTP delivery

**Constraints**: Arabic (RTL) primary support, offline-capable error states, no raw exceptions shown to user

**Scale/Scope**: Phase 1 — 7 Authentication screens, 4 Onboarding screens

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Reference: `.specify/memory/constitution.md` — **Quality & Governance Gates**

| Gate | Status | Notes |
|------|--------|-------|
| Architecture Gate | ✅ | Presentation / Domain / Data layers strictly followed. |
| State Gate | ✅ | Cubit used for all state. States are `sealed class`. |
| Error Gate | ✅ | `ApiResult<T>` used for all repository/use case returns. |
| Localization Gate | ✅ | No hardcoded strings. `slang` configured. |
| Theming Gate | ✅ | Design elements use `ThemeData` and `AppColorsExtension`. |
| Security Gate | ✅ | No secrets. JWTs in `flutter_secure_storage`. RLS for `users` table. |
| Test Gate | ✅ | Test plans explicitly state Unit, Cubit, and Widget coverage. |
| Dependency Gate | ✅ | Only pre-approved packages used (AGENTS.md §18). |
| Navigation Gate | ✅ | `go_router` named routes exclusively. |
| Phase Gate | ✅ | Only Phase 1 features implemented. Phase 2 Profile Setup is stubbed/navigated to. |

## Project Structure

### Documentation (this feature)

```text
specs/002-onboarding-auth/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit-tasks command - NOT created by /speckit-plan)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── router/               # Update routes.dart and app_router.dart (redirect logic)
│   └── services/
│       └── supabase/         # Update auth methods if not fully provided by Phase 0
├── features/
│   ├── onboarding/
│   │   ├── presentation/
│   │   │   ├── screens/      # Splash, Onboarding slides
│   │   │   ├── widgets/      # Page indicators, buttons
│   │   │   └── cubit/        # OnboardingCubit
│   │   ├── domain/
│   │   │   ├── repositories/ # OnboardingLocalRepository
│   │   │   └── use_cases/    # CheckOnboardingComplete, MarkOnboardingComplete
│   │   └── data/
│   │       └── repositories/ # OnboardingLocalRepositoryImpl (flutter_secure_storage)
│   └── auth/
│       ├── presentation/
│       │   ├── screens/      # Welcome, SignUp, Login, Email Verification, Phone OTP, Forgot Password
│       │   ├── widgets/      # Social login buttons, OTP input fields
│       │   └── cubit/        # AuthCubit, LoginCubit, SignUpCubit, OtpCubit
│       ├── domain/
│       │   ├── entities/     # UserEntity
│       │   ├── repositories/ # AuthRepository
│       │   └── use_cases/    # Login, SignUp, SendOtp, VerifyOtp, SocialLogin, SignOut, DeleteAccount
│       └── data/
│           ├── models/       # AuthUserModel, Request DTOs
│           ├── mappers/      # AuthUserMapper
│           └── repositories/ # AuthRepositoryImpl (Supabase integration)
```

**Structure Decision**: The feature is split into two modules (`onboarding` and `auth`) within the `lib/features/` directory as they represent distinct domains (local device state vs. remote authentication state).

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| None | N/A | N/A |
