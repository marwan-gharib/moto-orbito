# AGENT.md — Moto Orbito
<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->

> **Read this file completely before writing a single line of code.**
> This is the single source of truth for all engineering decisions in this project.
> Any instruction not found here defers to `GEMINI.md`.

---

## 1. Project Identity

| Field              | Value                                              |
| ------------------ | -------------------------------------------------- |
| App Name           | Moto Orbito                                        |
| Tagline            | Ride Together, Stay in Orbit                       |
| Platform           | Flutter — iOS & Android                            |
| Current Phase      | Phase 1 (62 screens across 10 modules)             |
| Architecture       | Feature-First Clean Architecture                   |
| State Management   | Cubit / Bloc (via `flutter_bloc`)                  |
| DI                 | `get_it`                                           |
| Navigation         | `go_router` (named routes only)                    |
| Networking         | `dio` via `BaseApiClient`                          |
| Backend            | Supabase (primary BaaS)                            |
| Push Notifications | Firebase Cloud Messaging (FCM)                     |
| AI Services        | External AI APIs (OpenAI / Gemini — see Section 7) |
| Localization       | `slang` — Arabic & English                         |
| Error Handling     | `ApiResult<T>` across all layers                   |

---

## 2. Phase Scope — What Exists NOW

Build **only** Phase 1 features. Do not scaffold, reference, or create any file
related to Phase 2 or Phase 3 unless explicitly instructed.

### Phase 1 Modules (in scope)

| # | Module               | Screens |
|---|----------------------|---------|
| 01 | Onboarding          | 4       |
| 02 | Authentication      | 7       |
| 03 | User Profile        | 5       |
| 04 | Motorcycle Profile  | 5       |
| 05 | Group Rides         | 10      |
| 06 | Live GPS Tracking   | 4       |
| 07 | AI Riding Analysis  | 5       |
| 08 | Maintenance Tracking| 6       |
| 09 | Notifications       | 2       |
| 10 | Dashboard           | 8       |
| —  | Shared/Global       | 6       |

### Out of Scope (Phase 2 & 3 — do not touch)

- SOS & Emergency (Module 11)
- Social Feed (Module 12)
- Group Chat (Module 13)
- Crash Detection (Module 14)

---

## 3. User Roles

| Role        | Permissions                                              |
| ----------- | -------------------------------------------------------- |
| Rider       | Join groups, participate in rides, view own data         |
| Group Admin | Manage rides, remove members (cannot delete group)       |
| Group Owner | Full control: edit group, promote/remove members, delete |

Role checks must live in the **Domain layer** (UseCases), never in widgets.
Never hardcode role strings — use a `UserRole` enum defined in `core/`.

---

## 4. Feature-First Folder Structure

```
lib/
├── core/
│   ├── di/                   # get_it registrations only
│   ├── router/               # app_router.dart + routes.dart
│   ├── network/              # BaseApiClient + interceptors
│   ├── error/                # Failure classes + ApiResult<T>
│   ├── widgets/              # AppButton, AppTextField, AppLoader, AppSnackBar, etc.
│   ├── extensions/           # BuildContext extensions
│   ├── theme/                # ThemeData + ThemeExtension (AppColorsExtension, etc.)
│   ├── utils/                # AppLogger, debounce helpers, constants
│   └── services/
│       ├── supabase/         # SupabaseClient wrapper + realtime helpers
│       ├── fcm/              # FCM service + token management
│       └── ai/               # AI API client (rate limiting, retry logic)
│
├── features/
│   ├── onboarding/
│   ├── auth/
│   ├── profile/
│   ├── motorcycle/
│   ├── group_rides/
│   ├── live_tracking/
│   ├── ai_analysis/
│   ├── maintenance/
│   ├── notifications/
│   └── dashboard/
│
└── main.dart
```

Each feature follows strict clean architecture layers:

```
features/featureName/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── cubit/              # cubit.dart + state.dart (sealed class)
├── domain/
│   ├── entities/
│   ├── repositories/       # abstract contracts only
│   └── use_cases/
└── data/
    ├── models/             # DTOs (JSON serialization)
    ├── mappers/            # DTO ↔ Entity, never elsewhere
    └── repositories/       # concrete implementations
```

---

## 5. Backend — Supabase Rules

### General
- Never call `supabase.from(...)` directly inside a Cubit, UseCase, or Widget
- All Supabase operations live in `data/repositories/` only
- Wrap every Supabase call in a try/catch → map to `Failure` → return `ApiResult`
- Use Supabase RLS (Row Level Security) for all tables — never trust client-side role checks alone

### Auth (Supabase Auth)
- Sign up: email + phone + password in one form → email OTP verification
- Social login: Google Sign-In, Facebook Sign-In (via Supabase OAuth)
- Forgot password: email reset link OR phone OTP
- Auto-login: handled via Supabase session persistence
- Account deletion: hard delete from `auth.users` + cascade to all user data

### Realtime (Live GPS Tracking & Ride Status)
- Use `supabase.channel(...)` for realtime subscriptions
- Active ride location updates → Supabase Realtime channel per `ride_id`
- Subscribe only while ride is `Active`, unsubscribe on `Stop Ride` or app background
- Location update payload: `{ rider_id, lat, lng, speed_kmh, timestamp }`
- Manage subscriptions inside `core/services/supabase/realtime_service.dart`

### Storage (Photos)
- Motorcycle photos → `motorcycles` bucket
- Group cover photos → `groups` bucket
- Profile photos → `profiles` bucket
- Max upload: 5MB per file
- Always upload via `core/services/supabase/storage_service.dart`, never inline

### Key Tables (reference only — schema owned by backend)

| Table                | Purpose                                      |
| -------------------- | -------------------------------------------- |
| `users`              | Rider profile + emergency info               |
| `motorcycles`        | Motorcycle data per user                     |
| `groups`             | Group info + invite code                     |
| `group_members`      | Members with roles                           |
| `rides`              | Ride sessions (upcoming/active/completed)    |
| `ride_participants`  | Riders in a specific ride                    |
| `ride_locations`     | GPS points per rider per ride                |
| `maintenance_logs`   | Service history entries                      |
| `maintenance_reminders` | Time/mileage reminder config              |
| `fuel_logs`          | Manual fuel entries                          |
| `notifications`      | In-app notification records                  |
| `geofences`          | User-defined geofence zones                  |

---

## 6. Firebase — FCM Rules

- FCM is used **only** for push notifications — no other Firebase service is used
- FCM token management lives in `core/services/fcm/fcm_service.dart`
- On login: register FCM token to Supabase `users` table field `fcm_token`
- On logout: clear `fcm_token` from Supabase
- Token refresh: handled automatically via `FirebaseMessaging.instance.onTokenRefresh`
- Foreground notifications: use `flutter_local_notifications` to display them
- Notification tap navigation: deep-link via `go_router` named routes

### Notification Types

| Type                    | Trigger                                   |
| ----------------------- | ----------------------------------------- |
| `ride_started`          | Owner/Admin starts a ride                 |
| `ride_ended`            | Ride session is stopped                   |
| `speed_alert`           | Rider exceeds configured speed limit      |
| `geofence_alert`        | Rider enters or exits a geofence zone     |
| `maintenance_due`       | Reminder threshold reached (time/mileage) |
| `insurance_expiry`      | 30, 7, and 1 day before expiry            |
| `registration_expiry`   | 30, 7, and 1 day before expiry            |
| `group_member_joined`   | New member joins the group                |
| `ride_invitation`       | User invited to a ride                    |
| `weekly_report_ready`   | AI weekly report is generated             |

Notification payload must always include a `type` field and a `target_id`
(e.g., `ride_id`, `group_id`, `motorcycle_id`) so the app knows where to navigate.

---

## 7. AI Integration Rules

AI is used in two places: **Ride Analysis** (Module 07) and **Maintenance Predictions** (Module 08).

### Where AI Lives
- All AI calls go through `core/services/ai/ai_service.dart`
- Never call an AI API directly from a UseCase or Cubit
- `AiService` must implement retry logic (max 2 retries) and timeout (30 seconds)
- AI responses are cached locally — never re-call for the same ride if a report exists

### Ride Report Generation (Post-Ride)
- Triggered automatically when a ride is stopped
- Input to AI: `{ ride_duration, total_distance, avg_speed, top_speed, hard_brake_count, rapid_accel_count, speed_violations, previous_score }`
- AI returns: `{ score: int, label: string, summary: string, tips: List<string> }`
- Response is saved to Supabase `ride_reports` table immediately after receipt
- If AI call fails: save ride data locally, retry in background — never block the user

### Maintenance Prediction
- Triggered when user opens the Maintenance Overview Screen
- Input: `{ mileage, last_service_date, last_service_mileage, hard_brake_count_since_last_service, ride_intensity }`
- AI returns: `{ prediction_text: string, recommended_km: int }`
- Cache prediction per motorcycle — refresh only when new rides are logged

### Weekly Report
- Generated server-side (via Supabase Edge Function) — client only fetches and displays
- AI generates the summary from the week's aggregated ride data

### Prompt Engineering
- All prompts are defined as constants in `core/services/ai/ai_prompts.dart`
- Never hardcode prompt strings inside service methods
- Always inject the user's language preference (`ar` / `en`) into the prompt

---

## 8. Live GPS Tracking — Critical Rules

GPS tracking is the flagship feature. Handle it with extreme care.

- Background location: use `geolocator` with `LocationAccuracy.high`
- GPS must continue when app is minimized (foreground service on Android, background mode on iOS)
- Location updates sent to Supabase Realtime every **3 seconds** during active ride
- Speed is calculated from GPS data (`position.speed` in m/s → convert to km/h)
- Speed Alert: compare against user-set threshold in `profile.speed_limit_kmh`
- Geofence: use `geofencer` package or manual distance calculation — flag choice before implementing
- On `Stop Ride`: unsubscribe all Realtime channels, stop GPS service, save full route, trigger AI analysis
- Route is saved as a list of `{ lat, lng, speed_kmh, timestamp }` points — batch-insert to Supabase at ride end

---

## 9. Motorcycle & Reminder Logic

- Each user can have **multiple motorcycles**; one is set as `is_primary = true`
- Changing the primary motorcycle updates `is_primary` on all others to `false` in a single transaction
- Insurance and registration expiry reminders: send FCM at **30 days**, **7 days**, and **1 day** before
- Reminder scheduling: handled via Supabase Edge Functions (cron) — not from the Flutter client
- Photo gallery: max **5 photos** per motorcycle; enforce on upload, show error if exceeded

---

## 10. Group Rides — Invite Code Logic

- 6-digit alphanumeric invite code generated on group creation
- Code is stored in `groups.invite_code` — unique constraint in DB
- Public groups: anyone can join without a code (code still exists for sharing)
- Private groups: code or invite link required to join
- Invite link format: `motoorbito://join/{invite_code}`
- Code regeneration: Owner only, via Group Settings

---

## 11. Localization Rules

- All user-visible strings in Arabic and English — no exceptions
- Arabic is the **primary language** (default for new users)
- `slang` key format: `context.t.featureName.screenName.keyName`
- RTL layout must be tested for every screen — Arabic is RTL
- Date formatting: use `intl` package → respect locale in all date displays
- Numbers: use locale-aware formatting (Arabic-Indic numerals for Arabic locale)
- Run `dart run slang` after every string addition

---

## 12. Offline & Error States

Every screen that loads remote data must handle:

| State    | Widget                                    |
| -------- | ----------------------------------------- |
| Loading  | `AppLoader` / Skeleton shimmer            |
| Empty    | `EmptyStateWidget` with contextual CTA    |
| Error    | `ErrorWidget` with Retry button           |
| Offline  | `NoInternetScreen` with cached data notice|

- Check connectivity before every API call — use `connectivity_plus`
- Cache critical data locally: user profile, active motorcycle, maintenance reminders
- Never show raw error messages to the user — map `Failure` to user-friendly strings via localization

---

## 13. Navigation Map (go_router)

All routes must be named constants in `core/router/routes.dart`.
Pass only primitive IDs between screens — never full objects.

```
/splash
/onboarding
/welcome
/sign-up
/verify-email
/login
/phone-otp
/forgot-password
/profile-setup
/home                    ← Dashboard (bottom nav root)
/groups
/groups/:groupId
/groups/:groupId/members
/groups/:groupId/settings
/groups/:groupId/rides
/groups/:groupId/rides/:rideId
/live-map/:rideId
/ride-replay/:rideId
/maintenance
/maintenance/add
/maintenance/:logId
/maintenance/history
/maintenance/calendar
/notifications
/profile
/profile/edit
/profile/emergency
/settings
/motorcycles
/motorcycles/add
/motorcycles/:motoId
/motorcycles/:motoId/edit
/motorcycles/:motoId/photos
/ai/report/:rideId
/ai/history
/ai/weekly
/fuel
/fuel/add
/geofences
/search
```

---

## 14. Theming

- ❌ Never use raw colors, hardcoded sizes, or `AppColors` directly
- ✅ All colors via `AppColorsExtension` on `ThemeData`
- ✅ All text styles via `theme.textTheme`
- ✅ Spacing via `ThemeExtension` constants or a `Spacing` class in `core/theme/`
- Dark mode and Light mode must both be implemented from day one
- Primary brand color palette: define in `core/theme/app_colors_extension.dart`

---

## 15. Performance Rules

- GPS screen and Live Map are performance-critical — minimize `setState` and unnecessary rebuilds
- Use `BlocSelector` whenever only a subset of Cubit state is needed
- Rider markers on the live map: update position smoothly (animate, don't redraw)
- Debounce search input: 400ms minimum
- Paginate all list screens (rides history, notifications, maintenance logs) — 20 items per page
- Pagination logic lives in Repository layer only

---

## 16. Security Rules

- Never store Supabase `service_role` key in the Flutter app — use `anon` key only
- JWT tokens stored securely via `flutter_secure_storage` — never `SharedPreferences`
- Emergency contact info and blood type are sensitive — never log them
- Geofence zone data is personal — RLS must restrict to owner only
- API keys for AI services: stored in Supabase Edge Function environment variables, never in the Flutter app
- All AI requests go through a Supabase Edge Function proxy — never directly from the client

---

## 17. Testing Requirements

Every feature is **incomplete** without tests. This is non-negotiable.

| Layer           | What to test                                                         |
| --------------- | -------------------------------------------------------------------- |
| Domain/UseCases | All success, failure, and edge-case paths                            |
| Data/Repos      | Supabase mock responses, error mapping, DTO parsing                  |
| Cubit           | Every state transition: initial → loading → success / error / empty  |
| Widgets         | Key interactions: form submission, navigation, error display          |

- One behavior per test — no multi-assertion mega-tests
- Bug fix = must include a regression test
- Use `mocktail` for mocking — no `mockito`

---

## 18. Dependency Approval List

* The following packages are **pre-approved**. Any package not on this list requires explicit approval before use.
* Any package must be a latest stable version, good pub.dev score, and frequently updated.

| Package                    | Purpose                              |
| -------------------------- | ------------------------------------ |
| `flutter_bloc`             | State management (Cubit/Bloc)        |
| `get_it`                   | Dependency injection                 |
| `go_router`                | Navigation                           |
| `dio`                      | HTTP client                          |
| `supabase_flutter`         | Supabase BaaS client                 |
| `firebase_core`            | Firebase initialization              |
| `firebase_messaging`       | FCM push notifications               |
| `flutter_local_notifications` | Foreground notification display   |
| `geolocator`               | GPS location tracking                |
| `google_maps_flutter`      | Map rendering                        |
| `google_sign_in`           | Google OAuth                         |
| `flutter_facebook_auth`    | Facebook OAuth                       |
| `flutter_secure_storage`   | Secure token storage                 |
| `connectivity_plus`        | Network connectivity check           |
| `slang`                    | Localization                         |
| `intl`                     | Date/number formatting               |
| `mocktail`                 | Test mocking                         |
| `fl_chart`                 | Charts (dashboard stats)             |
| `cached_network_image`     | Image loading with cache             |
| `image_picker`             | Photo selection                      |
| `google_maps_flutter`      | Maps                                 |
| `path_provider`            | File system access                   |
| `intl`                     | Date/number formatting               |
| `flutter_screenutil`       | Manage responsive sizes & design     |
| `equatable`                | Entity/Model comparison              |

---

## 19. What the AI Agent Must NEVER Do

1. ❌ Write business logic inside widgets, `initState`, or `build()`
2. ❌ Call Supabase, FCM, or AI APIs directly from a Cubit or UseCase
3. ❌ Use `Navigator.push` — go_router only
4. ❌ Hardcode any string visible to the user
5. ❌ Hardcode any color or text style
6. ❌ Use `FutureBuilder` with Cubit state
7. ❌ Pass full entity/model objects via navigation — IDs only
8. ❌ Add a new package without listing it in the approval request
9. ❌ Map DTOs to entities anywhere except Mapper classes
10. ❌ Store AI API keys, Supabase service keys, or any secrets in Flutter code
11. ❌ Build or reference any Phase 2 or Phase 3 feature without explicit instruction
12. ❌ Skip tests — a feature without tests is not complete
13. ❌ Use `print()` — use `AppLogger` only
14. ❌ Swallow exceptions silently
15. ❌ Rename, move, or delete existing files without explicit instruction

---

## 20. Android Flavors

The project has **two Android flavors** already configured: `development` and `production`.

### Flavor Overview

| Flavor        | App Name          | Supabase Project  | Entry Point                  |
| ------------- | ----------------- | ----------------- | ---------------------------- |
| `development` | Moto Orbito (Dev) | `moto-orbito-dev` | `lib/main_development.dart`  |
| `production`  | Moto Orbito       | `moto-orbito`     | `lib/main_production.dart`   |

### How Flavors Work

- Each flavor has its **own entry point file** (`main_development.dart` / `main_production.dart`)
- Each entry point calls `runApp()` with its own Supabase credentials and configuration hardcoded directly in that file
- There is **no `AppConfig` class**, **no `--dart-define`**, and **no `.env` file** — credentials live in the entry point files, which are gitignored or access-controlled
- The flavor determines everything: which Supabase project to connect to, whether logging is enabled, and any other environment-specific behavior

### Flavor-Specific Behavior Rules

- `AppLogger` is **enabled only in the `development` flavor** — it must be disabled (no-op) in `production`
- Any debug tooling, banners, or verbose output must be gated to `development` only
- Both flavors connect to **completely separate** Supabase projects — they share no data
- Both flavors can be installed side-by-side on the same device (different `applicationId`)

### What the AI Agent Must Do

- **Never** create an `AppConfig` class, use `--dart-define`, or read from `.env` for flavor config
- **Never** use `kDebugMode` or `kReleaseMode` as a proxy for flavor — they are not the same thing
- **Never** add flavor-specific logic inside shared code (features, services, cubits) — flavor differences belong only in the entry point files and `AppLogger`
- When a task says "log X" or "print Y", always route it through `AppLogger` — which self-disables in production
- Do not touch or modify `main_development.dart` or `main_production.dart` unless explicitly instructed

---

## 21. Decision Log

| Decision                         | Choice                          | Reason                                         |
| -------------------------------- | ------------------------------- | ---------------------------------------------- |
| Backend                          | Supabase                        | Auth + DB + Realtime + Storage in one platform |
| Push Notifications               | Firebase FCM                    | Industry standard, reliable delivery           |
| AI calls from client             | Via Supabase Edge Function proxy| Keys never exposed in Flutter app              |
| Realtime tracking protocol       | Supabase Realtime channels      | Already in the stack, no extra infra           |
| Local secure storage             | `flutter_secure_storage`        | JWT tokens must not be in SharedPreferences    |
| Primary language                 | Arabic (RTL)                    | Target market                                  |

---