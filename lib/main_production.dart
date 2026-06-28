import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_logger.dart';

const String _supabaseUrl = 'https://moto-orbito.supabase.co';
const String _supabaseAnonKey = 'replace-with-production-anon-key';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init(enabled: false);
  await initDependencies(
    supabaseUrl: _supabaseUrl,
    supabaseAnonKey: _supabaseAnonKey,
  );
  runApp(const MotoOrbitoApp());
}
