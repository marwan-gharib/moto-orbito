import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/login.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/login_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/login_state.dart';

class MockLogin extends Mock implements Login {}

void main() {
  late Login login;
  late LoginCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      LoginParams(email: 'fallback@test.com', password: 'fallback123'),
    );
  });

  setUp(() {
    login = MockLogin();
    cubit = LoginCubit(login);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is LoginInitial', () {
    expect(cubit.state, const LoginInitial());
  });

  group('login', () {
    test('emits [LoginLoading, LoginSuccess] on success', () async {
      when(() => login(any())).thenAnswer(
        (_) async => Success(
          UserEntity(
            id: 'uid-1',
            email: 'test@test.com',
            fullName: 'Test',
            createdAt: DateTime(2026),
          ),
        ),
      );

      final states = await cubit
          .login(email: 'test@test.com', password: 'password123')
          .toList();

      expect(states[0], const LoginLoading());
      expect(states[1], isA<LoginSuccess>());
    });

    test('emits [LoginLoading, LoginError] on failure', () async {
      when(() => login(any())).thenAnswer(
        (_) async => const Failure(
          AuthFailure(messageKey: 'auth.invalidCredentials'),
        ),
      );

      final states = await cubit
          .login(email: 'test@test.com', password: 'wrong')
          .toList();

      expect(states[0], const LoginLoading());
      expect(states[1], isA<LoginError>());
    });
  });
}
