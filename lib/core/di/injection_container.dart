import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/app_logger.dart';
import 'core_module.dart';

final sl = GetIt.instance;

bool supabaseInitialized = false;

Future<void> initDependencies({
  required String supabaseUrl,
  required String supabaseAnonKey,
}) async {
  try {
    await Firebase.initializeApp();
  } on Object catch (error, stackTrace) {
    AppLogger.warning('Firebase initialization failed');
    AppLogger.error(
      'Firebase initialization error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  try {
    if (!supabaseInitialized) {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseAnonKey,
      );
      supabaseInitialized = true;
    }
  } on Object catch (error, stackTrace) {
    supabaseInitialized = false;
    AppLogger.warning('Supabase initialization failed');
    AppLogger.error(
      'Supabase initialization error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  registerCoreModule(baseUrl: supabaseUrl);
}
