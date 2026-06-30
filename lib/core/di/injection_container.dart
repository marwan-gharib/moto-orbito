import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/di/auth_module.dart';
import '../../features/onboarding/di/onboarding_module.dart';
import '../utils/app_logger.dart';
import 'core_module.dart';

final sl = GetIt.instance;

bool supabaseInitialized = false;

Future<void> initDependencies({
  required String supabaseUrl,
  required String supabaseAnonKey,
}) async {
  // try {
  //   await Firebase.initializeApp();
  // } catch (error, stackTrace) {
  //   AppLogger.warning('Firebase initialization failed');
  //   AppLogger.error(
  //     'Firebase initialization error',
  //     error: error,
  //     stackTrace: stackTrace,
  //   );
  // }

  try {
    if (!supabaseInitialized) {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseAnonKey,
      );
      supabaseInitialized = true;
      AppLogger.info('Supabase initialized successfully');
    }
  } catch (error, stackTrace) {
    supabaseInitialized = false;
    AppLogger.warning('Supabase initialization failed');
    AppLogger.error(
      'Supabase initialization error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  registerCoreModule(baseUrl: supabaseUrl);
  registerAuthModule();
  registerOnboardingModule();
}
