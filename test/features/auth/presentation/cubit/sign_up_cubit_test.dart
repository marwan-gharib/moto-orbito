import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/sign_up.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/sign_up_state.dart';

class MockSignUp extends Mock implements SignUp {}

void main() {
  late SignUp signUp;
  late SignUpCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      SignUpParams(
        email: 'fallback@test.com',
        password: 'fallback123',
        fullName: 'Fallback',
        phone: '+971500000000',
      ),
    );
  });

  setUp(() {
    signUp = MockSignUp();
    cubit = SignUpCubit(signUp);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is SignUpInitial', () {
    expect(cubit.state, const SignUpInitial());
  });

  group('signUp', () {
    test('emits [SignUpLoading, SignUpSuccess] on success', () async {
      when(() => signUp(any())).thenAnswer(
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
          .signUp(
            email: 'test@test.com',
            password: 'password123',
            fullName: 'Test',
            phone: '+971501234567',
          )
          .toList();

      expect(states[0], const SignUpLoading());
      expect(states[1], const SignUpSuccess());
    });

    test('emits [SignUpLoading, SignUpError] on failure', () async {
      when(() => signUp(any())).thenAnswer(
        (_) async => const Failure(
          AuthFailure(messageKey: 'auth.emailAlreadyExists'),
        ),
      );

      final states = await cubit
          .signUp(
            email: 'test@test.com',
            password: 'password123',
            fullName: 'Test',
            phone: '+971501234567',
          )
          .toList();

      expect(states[0], const SignUpLoading());
      expect(states[1], isA<SignUpError>());
    });
  });
}
