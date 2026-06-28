# Dependency Injection (DI) Convention

This directory manages the dependency injection container for the application. The project relies on `get_it` for registering and locating services.

### Core vs Feature Registration
- `core_module.dart` is responsible for setting up globally accessible, foundational dependencies (e.g. `BaseApiClient`, `SupabaseService`, `AiService`, `FcmService`). These are typically configured as singletons (`registerLazySingleton`).
- Each feature should define its own module (e.g. `feature_module.dart`) under its respective feature directory, keeping its DI encapsulated. Feature modules register UseCases, Repositories, and Cubits (`registerFactory`).
- `injection_container.dart` acts as the master orchestrator, resolving all modules during app startup.

### Example Usage:
```dart
// feature/example/di/example_module.dart
import 'package:get_it/get_it.dart';

void registerExampleModule() {
  final getIt = GetIt.instance;
  
  // Repositories
  getIt.registerLazySingleton<ExampleRepository>(() => ExampleRepositoryImpl(getIt()));
  
  // UseCases
  getIt.registerLazySingleton(() => ExampleUseCase(getIt()));
  
  // Cubits (always use registerFactory)
  getIt.registerFactory(() => ExampleCubit(getIt()));
}
```
