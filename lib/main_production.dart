import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_logger.dart';

const String _supabaseUrl = 'https://regrgnhjsdklttmpoxbd.supabase.co';
const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJlZ3Jnbmhqc2RrbHR0bXBveGJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI2MTM3MDQsImV4cCI6MjA5ODE4OTcwNH0.hQEuvMOn2UnN_ZLFHJuUgdjNVU0DvxKujYBvgmBWiJ8';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.init(enabled: false);
  await ScreenUtil.ensureScreenSize();
  await initDependencies(
    supabaseUrl: _supabaseUrl,
    supabaseAnonKey: _supabaseAnonKey,
  );
  runApp(const MotoOrbitoApp());
}
