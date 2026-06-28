# Data Model: Project Foundation & Core Infrastructure (Phase 0)

**Date**: 2026-06-28
**Feature**: [spec.md](spec.md) | **Plan**: [plan.md](plan.md)

Phase 0 is infrastructure-only. There are no Supabase tables owned by this phase.
The entities below are Dart-layer types (classes/sealed classes) that represent
the cross-cutting data contracts all feature modules will depend on.

---

## 1. ApiResult\<T\>

**Kind**: Dart sealed class (generic)
**File**: `lib/core/error/api_result.dart`
**Layer**: Core (used across all layers)

| Subtype | Fields | Description |
|---------|--------|-------------|
| `Success<T>` | `data: T` | Wraps a successful response value |
| `Failure<T>` | `failure: AppFailure` | Wraps a typed failure (never a raw exception) |

**Rules**:
- `T` must be non-nullable
- Every cross-layer method signature returns `Future<ApiResult<T>>`
- UI exhaustively switches on subtypes; no `is` checks permitted

---

## 2. AppFailure (abstract base + 7 subtypes)

**Kind**: Abstract Dart class hierarchy
**File**: `lib/core/error/failure.dart`
**Layer**: Core / Domain (created in Data, used by Domain, translated in Presentation)

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `messageKey` | `String` | Yes | Raw `slang` key, e.g. `"errors.network"`. Never a human-readable string. |

**Concrete Subtypes**:

| Class | Default messageKey | Extra Fields | When Used |
|-------|--------------------|--------------|-----------|
| `NetworkFailure` | `errors.network` | — | No connectivity, timeout |
| `ServerFailure` | `errors.server` | `statusCode: int?` | 5xx HTTP responses |
| `AuthFailure` | `errors.auth` | — | 401/403, Supabase auth errors |
| `NotFoundFailure` | `errors.notFound` | — | 404, missing Supabase record |
| `PermissionFailure` | `errors.permission` | — | RLS rejection, device permission denied |
| `StorageFailure` | `errors.storage` | — | File upload/download errors, 5MB limit exceeded |
| `UnexpectedFailure` | `errors.unexpected` | — | Catch-all for unclassified exceptions |

**Rules**:
- UI calls `context.t.errors.<key>` to translate; never reads raw exception messages
- `ServerFailure.statusCode` is optional metadata for logging only — never shown to user
- `AppFailure` MUST NOT carry a `BuildContext` or any localization instance

---

## 3. NotificationPayload

**Kind**: Dart data class
**File**: `lib/core/services/fcm/fcm_service.dart` (internal model)
**Layer**: Core Service

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `type` | `String` | Yes | Notification category, e.g. `"ride_started"`, `"maintenance_due"` |
| `targetId` | `String?` | No | ID of the related entity (ride, group, motorcycle) |

**Valid `type` values** (Phase 1 consumers will use these constants):

| Value | Navigation Target |
|-------|------------------|
| `ride_started` | `/live-map/:rideId` |
| `ride_ended` | `/groups/:groupId/rides/:rideId` |
| `speed_alert` | `/live-map/:rideId` |
| `geofence_alert` | `/live-map/:rideId` |
| `maintenance_due` | `/maintenance/:logId` |
| `insurance_expiry` | `/motorcycles/:motoId` |
| `registration_expiry` | `/motorcycles/:motoId` |
| `group_member_joined` | `/groups/:groupId/members` |
| `ride_invitation` | `/groups/:groupId/rides/:rideId` |
| `weekly_report_ready` | `/ai/weekly` |

**Rules**:
- Unrecognized `type` values: log warning via `AppLogger.warning()`; do not crash; navigate to `/home`
- `targetId` null check required before use — some notification types carry no target

---

## 4. DeepLinkIntent

**Kind**: Dart value class (plain object)
**File**: `lib/core/router/deep_link_intent.dart`
**Layer**: Core / Router

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `uri` | `String` | Yes | The raw URI that triggered the deep link (e.g. `motoorbito://join/ABC123`) |

**Storage**: Serialized as plain string to `flutter_secure_storage` under key `pending_deep_link`.

**Lifecycle**:
1. Incoming deep link + unauthenticated → serialize URI → write to secure storage → redirect to auth
2. Successful login → read secure storage → parse URI → navigate via GoRouter → clear storage
3. No pending intent → secure storage returns null → no action

---

## 5. AppRoute (Route Name Constants)

**Kind**: Dart abstract class with static string constants
**File**: `lib/core/router/routes.dart`
**Layer**: Core / Router

All 34 routes from the navigation map are defined as `static const String` values.
Feature modules reference `AppRoute.home`, `AppRoute.liveMap`, etc. — never raw strings.

**Selected constants** (full list in [navigation-contracts.md](contracts/navigation-contracts.md)):

| Constant | Value | Notes |
|----------|-------|-------|
| `AppRoute.splash` | `/splash` | — |
| `AppRoute.home` | `/home` | Dashboard root (bottom nav) |
| `AppRoute.noConnection` | `/no-connection` | Supabase init failure screen |
| `AppRoute.liveMap` | `/live-map/:rideId` | Requires `rideId` path param |
| `AppRoute.joinGroup` | `/groups/join/:inviteCode` | Handles invite deep link |

---

## 6. AppColorsExtension

**Kind**: Flutter `ThemeExtension<AppColorsExtension>`
**File**: `lib/core/theme/app_colors_extension.dart`
**Layer**: Core / Theme

| Token | Type | Light Value | Dark Value | Usage |
|-------|------|-------------|------------|-------|
| `primary` | `Color` | `#FF6B00` (brand orange) | `#FF8C33` | CTAs, active nav |
| `primaryVariant` | `Color` | `#CC5500` | `#FF6B00` | Pressed states |
| `onPrimary` | `Color` | `#FFFFFF` | `#1A1A1A` | Text on primary |
| `surface` | `Color` | `#FFFFFF` | `#1A1A1A` | Cards, sheets |
| `onSurface` | `Color` | `#1A1A1A` | `#F5F5F5` | Body text |
| `background` | `Color` | `#F5F5F5` | `#121212` | Page background |
| `onBackground` | `Color` | `#1A1A1A` | `#E0E0E0` | General text |
| `error` | `Color` | `#D32F2F` | `#EF9A9A` | Error states |
| `onError` | `Color` | `#FFFFFF` | `#1A1A1A` | Text on error |
| `success` | `Color` | `#388E3C` | `#A5D6A7` | Success states |
| `warning` | `Color` | `#F57C00` | `#FFCC80` | Warning states |
| `divider` | `Color` | `#E0E0E0` | `#2C2C2C` | Separators |
| `skeleton` | `Color` | `#E0E0E0` | `#2C2C2C` | Skeleton shimmer |

**Access pattern** (ONLY valid way to use colors):
```dart
// Via BuildContext extension:
context.colors.primary

// Direct (inside ThemeExtension itself):
Theme.of(context).extension<AppColorsExtension>()!.primary
```

---

## 7. Spacing

**Kind**: Dart abstract class with static constants
**File**: `lib/core/theme/spacing.dart`
**Layer**: Core / Theme

| Constant | Value | Usage |
|----------|-------|-------|
| `Spacing.xs` | `4.0` | Icon padding, tight gaps |
| `Spacing.sm` | `8.0` | Component internal padding |
| `Spacing.md` | `16.0` | Standard section padding |
| `Spacing.lg` | `24.0` | Card padding, section gaps |
| `Spacing.xl` | `32.0` | Screen-level top margins |
| `Spacing.xxl` | `48.0` | Hero section gaps |
