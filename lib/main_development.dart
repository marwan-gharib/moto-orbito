import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'core/di/injection_container.dart';
import 'core/utils/app_logger.dart';

const String _supabaseUrl = 'https://jwaflaezkduprmmjcywq.supabase.co';
const String _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3YWZsYWV6a2R1cHJtbWpjeXdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI2MDEyNzksImV4cCI6MjA5ODE3NzI3OX0._51t3okII4VOlgE8v6HF4xTplqzd2fDEqB28Alwuz-Y';

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
