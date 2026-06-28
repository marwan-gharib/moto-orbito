import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/screens/welcome_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

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
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
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
