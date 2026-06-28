import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/network/dio_client.dart';

import '../network/base_api_client.dart';
import '../router/app_router.dart';
import '../router/deep_link_intent.dart';
import '../services/ai/ai_service.dart';
import '../services/fcm/fcm_service.dart';
import '../services/supabase/realtime_service.dart';
import '../services/supabase/storage_service.dart';
import '../services/supabase/supabase_service.dart';
import 'injection_container.dart';

void registerCoreModule({required String baseUrl}) {
  final sl = GetIt.instance;

  if (!sl.isRegistered<FlutterSecureStorage>()) {
    sl.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
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
  if (!sl.isRegistered<AiService>()) {
    sl.registerLazySingleton<AiService>(() => AiService(sl()));
  }
  if (!sl.isRegistered<DeepLinkIntentStore>()) {
    sl.registerLazySingleton<DeepLinkIntentStore>(
      () => DeepLinkIntentStore(sl()),
    );
  }
  if (!sl.isRegistered<AppRouter>()) {
    sl.registerLazySingleton<AppRouter>(
      () => AppRouter(sl(), sl(), () => supabaseInitialized),
    );
  }
  if (!sl.isRegistered<GoRouter>()) {
    sl.registerLazySingleton<GoRouter>(() => sl<AppRouter>().router());
  }
  if (!sl.isRegistered<FlutterLocalNotificationsPlugin>()) {
    sl.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      FlutterLocalNotificationsPlugin.new,
    );
  }
  if (!sl.isRegistered<FirebaseMessaging>()) {
    sl.registerLazySingleton<FirebaseMessaging>(
      () => FirebaseMessaging.instance,
    );
  }
  if (!sl.isRegistered<FcmService>()) {
    sl.registerLazySingleton<FcmService>(
      () => FcmService(
        sl(),
        sl(),
        sl(),
        (location) => sl<GoRouter>().go(location),
      ),
    );
  }
}
