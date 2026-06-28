# Service Contracts: Core Infrastructure (Phase 0)

**Files**: `lib/core/network/`, `lib/core/services/`

---

## BaseApiClient

**File**: `lib/core/network/base_api_client.dart`

```dart
abstract interface class BaseApiClient {
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  });

  Future<ApiResult<T>> post<T>(
    String path, {
    required Map<String, dynamic> body,
    required T Function(dynamic json) fromJson,
  });

  Future<ApiResult<T>> put<T>(
    String path, {
    required Map<String, dynamic> body,
    required T Function(dynamic json) fromJson,
  });

  Future<ApiResult<void>> delete(String path);
}
```

**Interceptors** (applied in order):
1. `AuthInterceptor` — reads JWT from `flutter_secure_storage`, attaches as `Authorization: Bearer`
2. `LoggingInterceptor` — logs via `AppLogger.debug()` (no-op in production)
3. `ErrorInterceptor` — maps `DioException` subtypes → typed `Failure` → `ApiResult.Failure`

---

## SupabaseService

**File**: `lib/core/services/supabase/supabase_service.dart`

Thin wrapper; all Supabase calls live only here and in `data/repositories/`.

```dart
abstract interface class SupabaseService {
  // Returns initialized client (throws if not yet initialized)
  SupabaseClient get client;

  // Connection verification
  Future<ApiResult<void>> ping();
}
```

---

## RealtimeService

**File**: `lib/core/services/supabase/realtime_service.dart`

```dart
abstract interface class RealtimeService {
  // Subscribe to a ride's location channel
  void subscribeToRide({
    required String rideId,
    required void Function(Map<String, dynamic> payload) onEvent,
  });

  // Broadcast a location update (called every 3s during active ride)
  Future<void> broadcastLocation({
    required String rideId,
    required String riderId,
    required double lat,
    required double lng,
    required double speedKmh,
    required DateTime timestamp,
  });

  // Unsubscribe from all channels for a ride
  Future<void> unsubscribeFromRide(String rideId);
}
```

---

## StorageService

**File**: `lib/core/services/supabase/storage_service.dart`

```dart
abstract interface class StorageService {
  // Returns public URL of uploaded file, or StorageFailure if >5MB
  Future<ApiResult<String>> uploadFile({
    required String bucket,       // 'motorcycles' | 'groups' | 'profiles'
    required String path,
    required Uint8List bytes,
    required String mimeType,
  });

  Future<ApiResult<void>> deleteFile({
    required String bucket,
    required String path,
  });
}
```

**5MB limit**: enforced in `StorageService.uploadFile` BEFORE calling Supabase —
returns `StorageFailure` with `messageKey: 'errors.storage'` if `bytes.length > 5_242_880`.

---

## FcmService

**File**: `lib/core/services/fcm/fcm_service.dart`

```dart
abstract interface class FcmService {
  // Initialize FCM, request permission, store token, set up handlers
  Future<void> initialize();

  // Read pending token from secure storage (null if no pending token)
  Future<String?> getPendingToken();

  // Clear pending token after upload to Supabase on login
  Future<void> clearPendingToken();
}
```

**Internal behavior** (not exposed via interface but specified for implementation):
- Calls `FirebaseMessaging.instance.getToken()` → stores in `flutter_secure_storage('fcm_token_pending')`
- `onTokenRefresh` stream: writes new token to `fcm_token_pending`
- `onMessage` (foreground): displays via `flutter_local_notifications`
- `onMessageOpenedApp` + `getInitialMessage` (tap/cold start): parses `NotificationPayload`, navigates via GoRouter

---

## AiService

**File**: `lib/core/services/ai/ai_service.dart`

```dart
abstract interface class AiService {
  // Post a prompt to the Supabase Edge Function proxy
  // Retries up to 2 times; 30s timeout per attempt
  Future<ApiResult<Map<String, dynamic>>> invoke({
    required String promptKey,   // constant from AiPrompts
    required Map<String, dynamic> input,
    required String languageCode, // 'ar' | 'en'
  });
}
```

**AiPrompts file** (`lib/core/services/ai/ai_prompts.dart`):
```dart
abstract class AiPrompts {
  static const rideReport     = 'ride_report';
  static const maintenance    = 'maintenance_prediction';
  static const weeklyReport   = 'weekly_report';
}
```

**Failure behavior**: After 2 failed retries → `ServerFailure`. Caller (Phase 1 repository)
is responsible for local caching and background retry — `AiService` does not cache.
