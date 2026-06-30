import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/theme/app_colors_extension.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/screens/welcome_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

Widget _createTestApp(Widget child) {
  const colorsExt = AppColorsExtension(
    success: Color(0xFF388E3C),
    warning: Color(0xFFF57C00),
    skeleton: Color(0xFFE0E0E0),
    neonAccent: Color(0xFFFF6B00),
    surfaceCard: Color(0xFF16161E),
  );
  final theme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0F),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFF6B00),
      onPrimary: Color(0xFF1A1A1A),
      surface: Color(0xFF1A1A1A),
      onSurface: Color(0xFFF5F5F5),
    ),
    extensions: [colorsExt],
  );

  return MaterialApp(
    theme: theme,
    home: child,
  );
}

void main() {
  late AuthRepository repository;
  late AuthCubit authCubit;

  setUp(() {
    repository = MockAuthRepository();
    authCubit = AuthCubit(repository);
  });

  tearDown(() {
    authCubit.close();
  });

  testWidgets('shows welcome screen with social login buttons',
      (tester) async {
    await tester.pumpWidget(
      _createTestApp(
        BlocProvider<AuthCubit>.value(
          value: authCubit,
          child: const WelcomeScreen(),
        ),
      ),
    );

    expect(find.text('مرحباً بك في موتو أوربيتو'), findsOneWidget);
    expect(find.text('المتابعة عبر Google'), findsOneWidget);
    expect(find.text('المتابعة عبر Facebook'), findsOneWidget);
    expect(find.text('إنشاء حساب'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
