import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/core/error/failure_type.dart';
import 'package:moto_orbito/core/error/strategies/strategies.dart';
import 'package:moto_orbito/core/network/dio_client.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../local/cache/cache_service.dart';
import '../local/cache/shared_prefrences_service.dart';
import '../local/secure/flutter_secure_storage_client.dart';
import '../local/secure/secure_storage_client.dart';
import '../network/base_api_client.dart';
import '../router/app_router.dart';
import '../router/deep_link_intent.dart';
import '../services/supabase/realtime_service.dart';
import '../services/supabase/storage_service.dart';
import '../services/supabase/supabase_service.dart';
import 'injection_container.dart';

void registerCoreModule({required String baseUrl}) {
  final sl = GetIt.instance;

  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
  }
  if (!sl.isRegistered<SharedPreferences>()) {
    sl.registerSingletonAsync<SharedPreferences>(SharedPreferences.getInstance);
  }
  if (!sl.isRegistered<CacheService>()) {
    sl.registerLazySingleton<CacheService>(
      () => SharedPreferencesService(sl<SharedPreferences>()),
    );
  }
  if (!sl.isRegistered<SecureStorageClient>()) {
    sl.registerLazySingleton<SecureStorageClient>(
      () => FlutterSecureStorageClient(sl<FlutterSecureStorage>()),
    );
  }
  if (!sl.isRegistered<Connectivity>()) {
    sl.registerLazySingleton<Connectivity>(Connectivity.new);
  }
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(() => Dio(BaseOptions(baseUrl: baseUrl)));
  }
  if (!sl.isRegistered<BaseApiClient>()) {
    sl.registerLazySingleton<BaseApiClient>(
      () => DioClient(sl(), sl(), storage: sl()),
    );
  }
  if (!sl.isRegistered<SupabaseService>()) {
    sl.registerLazySingleton<SupabaseService>(SupabaseService.new);
  }
  if (!sl.isRegistered<RealtimeService>()) {
    sl.registerLazySingleton<RealtimeService>(() => RealtimeService(sl()));
  }
  if (!sl.isRegistered<StorageService>()) {
    sl.registerLazySingleton<StorageService>(() => StorageService(sl()));
  }
  // if (!sl.isRegistered<AiService>()) {
  //   sl.registerLazySingleton<AiService>(() => AiService(sl()));
  // }

  registerFailureModule();

  if (!sl.isRegistered<DeepLinkIntentStore>()) {
    sl.registerLazySingleton<DeepLinkIntentStore>(
      () => DeepLinkIntentStore(sl()),
    );
  }
  if (!sl.isRegistered<AppRouter>()) {
    sl.registerLazySingleton<AppRouter>(
      () => AppRouter(sl<AuthCubit>(), sl(), () => supabaseInitialized),
    );
  }
  if (!sl.isRegistered<GoRouter>()) {
    sl.registerLazySingleton<GoRouter>(() => sl<AppRouter>().router());
  }
  // if (!sl.isRegistered<FlutterLocalNotificationsPlugin>()) {
  //   sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
  //     FlutterLocalNotificationsPlugin.new,
  //   );
  // }
  // if (!sl.isRegistered<FirebaseMessaging>()) {
  //   sl.registerLazySingleton<FirebaseMessaging>(
  //     () => FirebaseMessaging.instance,
  //   );
  // }
  // if (!sl.isRegistered<FcmService>()) {
  //   sl.registerLazySingleton<FcmService>(
  //     () => FcmService(
  //       sl(),
  //       sl(),
  //       sl(),
  //       (location) => sl<GoRouter>().go(location),
  //     ),
  //   );
  // }
}

void registerFailureModule() {
  final sl = GetIt.instance;

  if (!sl.isRegistered<NetworkFailureStrategy>()) {
    sl.registerLazySingleton<NetworkFailureStrategy>(NetworkFailureStrategy.new);
  }
  if (!sl.isRegistered<ServerFailureStrategy>()) {
    sl.registerLazySingleton<ServerFailureStrategy>(ServerFailureStrategy.new);
  }
  if (!sl.isRegistered<AuthFailureStrategy>()) {
    sl.registerLazySingleton<AuthFailureStrategy>(AuthFailureStrategy.new);
  }
  if (!sl.isRegistered<NotFoundFailureStrategy>()) {
    sl.registerLazySingleton<NotFoundFailureStrategy>(NotFoundFailureStrategy.new);
  }
  if (!sl.isRegistered<PermissionFailureStrategy>()) {
    sl.registerLazySingleton<PermissionFailureStrategy>(PermissionFailureStrategy.new);
  }
  if (!sl.isRegistered<StorageFailureStrategy>()) {
    sl.registerLazySingleton<StorageFailureStrategy>(StorageFailureStrategy.new);
  }
  if (!sl.isRegistered<UnexpectedFailureStrategy>()) {
    sl.registerLazySingleton<UnexpectedFailureStrategy>(UnexpectedFailureStrategy.new);
  }

  if (!sl.isRegistered<FailureMessageResolver>()) {
    final authStrategy = sl<AuthFailureStrategy>();
    sl.registerLazySingleton<FailureMessageResolver>(
      () => FailureMessageResolver({
        FailureType.network: sl<NetworkFailureStrategy>(),
        FailureType.server: sl<ServerFailureStrategy>(),
        FailureType.notFound: sl<NotFoundFailureStrategy>(),
        FailureType.permission: sl<PermissionFailureStrategy>(),
        FailureType.storage: sl<StorageFailureStrategy>(),
        FailureType.unexpected: sl<UnexpectedFailureStrategy>(),
        FailureType.auth: authStrategy,
        FailureType.emailAlreadyExists: authStrategy,
        FailureType.emailNotVerified: authStrategy,
        FailureType.invalidCredentials: authStrategy,
        FailureType.otpExpired: authStrategy,
        FailureType.invalidOtp: authStrategy,
      }),
    );
  }
}
