import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_logger.dart';

const String _supabaseUrl = 'https://moto-orbito-dev.supabase.co';
const String _supabaseAnonKey = 'replace-with-development-anon-key';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  AppLogger.init(enabled: true);
  await initDependencies(
    supabaseUrl: _supabaseUrl,
    supabaseAnonKey: _supabaseAnonKey,
  );
  runApp(const MotoOrbitoApp());
}
