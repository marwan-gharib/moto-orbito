# DI Contracts: Core Infrastructure (Phase 0)

**File**: `lib/core/di/injection_container.dart` + `lib/core/di/core_module.dart`

---

## Registration Contract

Every registration MUST follow these lifecycle rules (enforced by convention):

| Type | GetIt Method | Reason |
|------|-------------|--------|
| Cubit | `registerFactory` | Fresh instance per BlocProvider |
| UseCase | `registerLazySingleton` | Stateless; shared safely |
| Repository (abstract) | registered as implementation via `registerLazySingleton` | |
| Core services (Supabase, FCM, AI) | `registerLazySingleton` | Initialized once |
| `BaseApiClient` | `registerLazySingleton` | Single Dio instance |

## Core Module Registrations (Phase 0)

```
InjectionContainer.init()
└── coreModule()
    ├── AppLogger             (singleton — init called in entry points, not here)
    ├── BaseApiClient         (lazy singleton)
    ├── SupabaseService       (lazy singleton — wraps Supabase.instance.client)
    ├── RealtimeService       (lazy singleton)
    ├── StorageService        (lazy singleton)
    ├── FcmService            (lazy singleton)
    └── AiService             (lazy singleton)
```

## Feature Module Convention

Every Phase 1 feature creates `lib/features/<name>/di/<name>_module.dart` with:
```dart
void registerFeatureName() {
  final sl = GetIt.instance;
  sl.registerFactory(() => FeatureCubit(sl()));
  sl.registerLazySingleton(() => FeatureUseCase(sl()));
  sl.registerLazySingleton<FeatureRepository>(() => FeatureRepositoryImpl(sl()));
}
```

Then adds one line to `injection_container.dart`:
```dart
registerFeatureName();
```
