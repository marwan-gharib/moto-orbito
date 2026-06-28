---
description: "Task list for Onboarding & Authentication (Phase 1)"
---

# Tasks: Onboarding & Authentication

**Input**: Design documents from `/specs/002-onboarding-auth/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Test tasks are **MANDATORY** for every feature per the Moto Orbito constitution (Principle V — Test-First). Use `mocktail` for mocking. One behavior per test.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions (Moto Orbito — Flutter Feature-First)

- **Feature code**: `lib/features/<featureName>/{presentation,domain,data}/`
- **Core shared code**: `lib/core/`
- **Tests**: `test/features/<featureName>/` mirroring the feature structure
- **Unit tests (UseCases)**: `test/features/<featureName>/domain/`
- **Cubit tests**: `test/features/<featureName>/presentation/cubit/`
- **Widget tests**: `test/features/<featureName>/presentation/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure for the onboarding and auth features

- [ ] T001 Create project structure for `lib/features/onboarding/`
- [ ] T002 [P] Create project structure for `lib/features/auth/`
- [ ] T003 [P] Add required dependencies (`google_sign_in`, `flutter_facebook_auth`) to pubspec.yaml

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T004 Create `UserEntity` in `lib/features/auth/domain/entities/user_entity.dart`
- [ ] T005 [P] Create `AuthUserModel` in `lib/features/auth/data/models/auth_user_model.dart`
- [ ] T006 Implement `AuthUserMapper` in `lib/features/auth/data/mappers/auth_user_mapper.dart`
- [ ] T007 Define `AuthRepository` contract in `lib/features/auth/domain/repositories/auth_repository.dart`
- [ ] T008 Implement `AuthRepositoryImpl` in `lib/features/auth/data/repositories/auth_repository_impl.dart`
- [ ] T009 Create `AuthCubit` and `AuthState` in `lib/features/auth/presentation/cubit/auth_cubit.dart`
- [ ] T010 [P] Configure GoRouter top-level redirect for AuthCubit in `lib/core/router/app_router.dart`
- [ ] T011 Register all dependencies (AuthCubit, AuthRepository) in `lib/core/di/injection_container.dart`

**Checkpoint**: Foundation ready - auth state can be managed globally, user story implementation can begin.

---

## Phase 3: User Story 1 - First-Time App Launch & Onboarding (Priority: P1) 🎯 MVP

**Goal**: Show onboarding slides to first-time users, skip for returning users, and land on Welcome.

**Independent Test**: App launches, onboarding shows, skip/completion navigates to Welcome, subsequent launches skip onboarding.

### Tests for User Story 1 (MANDATORY per constitution — Test Gate) ✅

- [ ] T012 [P] [US1] Unit test for `CheckOnboardingComplete` use case in `test/features/onboarding/domain/use_cases/check_onboarding_complete_test.dart`
- [ ] T013 [P] [US1] Unit test for `MarkOnboardingComplete` use case in `test/features/onboarding/domain/use_cases/mark_onboarding_complete_test.dart`
- [ ] T014 [P] [US1] Cubit test for `OnboardingCubit` in `test/features/onboarding/presentation/cubit/onboarding_cubit_test.dart`
- [ ] T015 [P] [US1] Widget test for Onboarding slides in `test/features/onboarding/presentation/screens/onboarding_screen_test.dart`

### Implementation for User Story 1

- [ ] T016 [P] [US1] Implement `OnboardingLocalRepository` in `lib/features/onboarding/domain/repositories/onboarding_local_repository.dart`
- [ ] T017 [US1] Implement `OnboardingLocalRepositoryImpl` (using secure storage) in `lib/features/onboarding/data/repositories/onboarding_local_repository_impl.dart`
- [ ] T018 [US1] Implement UseCases `CheckOnboardingComplete` and `MarkOnboardingComplete` in `lib/features/onboarding/domain/use_cases/`
- [ ] T019 [US1] Implement `OnboardingCubit` in `lib/features/onboarding/presentation/cubit/onboarding_cubit.dart`
- [ ] T020 [P] [US1] Create UI `OnboardingScreen` and slides in `lib/features/onboarding/presentation/screens/onboarding_screen.dart`
- [ ] T021 [US1] Register onboarding dependencies in `lib/core/di/injection_container.dart`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently.

---

## Phase 4: User Story 2 - New User Registration Email + Phone (Priority: P1)

**Goal**: Full sign-up flow including email/password registration, email OTP, and optional phone OTP.

**Independent Test**: New user can register, receive email OTP, verify, optionally skip phone, and reach Profile Setup.

### Tests for User Story 2 (MANDATORY per constitution — Test Gate) ✅

- [ ] T022 [P] [US2] Unit test for `SignUp` use case in `test/features/auth/domain/use_cases/sign_up_test.dart`
- [ ] T023 [P] [US2] Unit test for `SendOtp`/`VerifyOtp` use cases in `test/features/auth/domain/use_cases/otp_use_cases_test.dart`
- [ ] T024 [P] [US2] Cubit test for `SignUpCubit` in `test/features/auth/presentation/cubit/sign_up_cubit_test.dart`
- [ ] T025 [P] [US2] Cubit test for `OtpCubit` in `test/features/auth/presentation/cubit/otp_cubit_test.dart`

### Implementation for User Story 2

- [ ] T026 [P] [US2] Create DTOs (`SignUpRequestModel`, `EmailParams`, `OtpVerifyParams`) in `lib/features/auth/data/models/`
- [ ] T027 [US2] Implement UseCases (`SignUp`, `SendOtp`, `VerifyOtp`) in `lib/features/auth/domain/use_cases/`
- [ ] T028 [US2] Implement `SignUpCubit` in `lib/features/auth/presentation/cubit/sign_up_cubit.dart`
- [ ] T029 [US2] Implement `OtpCubit` (with max 3 resends logic) in `lib/features/auth/presentation/cubit/otp_cubit.dart`
- [ ] T030 [P] [US2] Create UI `SignUpScreen` in `lib/features/auth/presentation/screens/sign_up_screen.dart`
- [ ] T031 [P] [US2] Create UI `EmailVerificationScreen` in `lib/features/auth/presentation/screens/email_verification_screen.dart`
- [ ] T032 [P] [US2] Create UI `PhoneOtpScreen` (optional step) in `lib/features/auth/presentation/screens/phone_otp_screen.dart`

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently.

---

## Phase 5: User Story 3 - Social Sign-In (Priority: P1)

**Goal**: Support Google and Facebook authentication natively, mapping to profile setup for new users.

**Independent Test**: User can log in via Google/FB and reach Profile Setup (first time) or Home (returning).

### Tests for User Story 3 (MANDATORY per constitution — Test Gate) ✅

- [ ] T033 [P] [US3] Unit test for `SocialLogin` use case in `test/features/auth/domain/use_cases/social_login_test.dart`
- [ ] T034 [P] [US3] Widget test for social login buttons on Welcome Screen in `test/features/auth/presentation/screens/welcome_screen_test.dart`

### Implementation for User Story 3

- [ ] T035 [US3] Implement `SocialLogin` use case in `lib/features/auth/domain/use_cases/social_login.dart`
- [ ] T036 [US3] Add social login handlers to `LoginCubit` or create `SocialAuthCubit` in `lib/features/auth/presentation/cubit/`
- [ ] T037 [P] [US3] Create UI `WelcomeScreen` (with social buttons) in `lib/features/auth/presentation/screens/welcome_screen.dart`

**Checkpoint**: Social authentication should now be fully functional.

---

## Phase 6: User Story 4 - Returning User Login (Priority: P1)

**Goal**: Email/password login with block for unverified users, plus session persistence.

**Independent Test**: Returning verified user can log in; unverified user is blocked and sent to OTP screen.

### Tests for User Story 4 (MANDATORY per constitution — Test Gate) ✅

- [ ] T038 [P] [US4] Unit test for `Login` use case in `test/features/auth/domain/use_cases/login_test.dart`
- [ ] T039 [P] [US4] Cubit test for `LoginCubit` in `test/features/auth/presentation/cubit/login_cubit_test.dart`

### Implementation for User Story 4

- [ ] T040 [P] [US4] Create `LoginRequestModel` in `lib/features/auth/data/models/login_request_model.dart`
- [ ] T041 [US4] Implement `Login` use case (with unverified user detection) in `lib/features/auth/domain/use_cases/login.dart`
- [ ] T042 [US4] Implement `LoginCubit` in `lib/features/auth/presentation/cubit/login_cubit.dart`
- [ ] T043 [P] [US4] Create UI `LoginScreen` in `lib/features/auth/presentation/screens/login_screen.dart`

**Checkpoint**: Standard email/password authentication fully complete.

---

## Phase 7: User Story 5 - Password Reset (Priority: P2)

**Goal**: Users can request a password reset email from the login screen.

**Independent Test**: Forgot password flow sends an email request via Supabase and shows success message.

### Tests for User Story 5 (MANDATORY per constitution — Test Gate) ✅

- [ ] T044 [P] [US5] Unit test for `ResetPassword` use case in `test/features/auth/domain/use_cases/reset_password_test.dart`

### Implementation for User Story 5

- [ ] T045 [US5] Implement `ResetPassword` use case in `lib/features/auth/domain/use_cases/reset_password.dart`
- [ ] T046 [P] [US5] Create UI `ForgotPasswordScreen` in `lib/features/auth/presentation/screens/forgot_password_screen.dart`

---

## Phase 8: User Story 6 - Account Deletion (Priority: P3)

**Goal**: Authenticated user can delete their account securely using the confirmation phrase "DELETE".

**Independent Test**: Deletion phrase "DELETE" enables button; edge function clears account.

### Tests for User Story 6 (MANDATORY per constitution — Test Gate) ✅

- [ ] T047 [P] [US6] Unit test for `DeleteAccount` use case in `test/features/auth/domain/use_cases/delete_account_test.dart`

### Implementation for User Story 6

- [ ] T048 [US6] Implement `DeleteAccount` use case in `lib/features/auth/domain/use_cases/delete_account.dart`
- [ ] T049 [US6] Add deletion logic to `AuthCubit` or `ProfileCubit` in `lib/features/auth/presentation/cubit/auth_cubit.dart`
- [ ] T050 [P] [US6] Create UI confirmation dialog/screen for Account Deletion in `lib/features/auth/presentation/widgets/account_deletion_dialog.dart`

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] T051 Run `dart run slang` to generate localization files for all new auth and onboarding strings.
- [ ] T052 Verify all error states correctly map to `AppFailure` localized messages (No raw exceptions).
- [ ] T053 Manually execute the `quickstart.md` validation scenarios.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies
- **User Story 2 (P1)**: Can start after Foundational (Phase 2) - No dependencies
- **User Story 3 (P1)**: Can start after Foundational (Phase 2) - No dependencies
- **User Story 4 (P1)**: Can start after Foundational (Phase 2) - No dependencies
- **User Story 5 (P2)**: Can start after Foundational (Phase 2) - Independent from other flows
- **User Story 6 (P3)**: Can start after Foundational (Phase 2) - Dependent on user being authenticated

### Within Each User Story

- Tests MUST be written and FAIL before implementation (Test-First — constitution Principle V)
- Models before services/use cases
- Use cases before cubits
- Cubits before screens/widgets
- Story complete before moving to next priority

### Parallel Opportunities

- Setup tasks and Foundational Data/Domain creation can run in parallel.
- US1 (Onboarding) and US2 (Auth/Sign Up) operate in completely different directories and can be built completely in parallel.
- UI Screens (`SignUpScreen`, `LoginScreen`, `WelcomeScreen`) can be mocked in parallel before cubits are finished.
