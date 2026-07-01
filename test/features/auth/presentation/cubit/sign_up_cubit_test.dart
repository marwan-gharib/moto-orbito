import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/sign_up.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/sign_up_cubit/sign_up_state.dart';

class MockSignUp extends Mock implements SignUp {}

class MockFailureMessageResolver extends Mock
    implements FailureMessageResolver {}

final _testUser = UserEntity(
  id: 'uid-1',
  email: 'test@test.com',
  fullName: 'Test',
  createdAt: DateTime(2026),
);

void main() {
  late SignUp signUp;
  late FailureMessageResolver messageResolver;
  late SignUpCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      SignUpParams(
        email: 'fallback@test.com',
        password: 'fallback123',
        fullName: 'Fallback',
      ),
    );
    registerFallbackValue(const NetworkFailure());
  });

  setUp(() {
    signUp = MockSignUp();
    messageResolver = MockFailureMessageResolver();
    cubit = SignUpCubit(signUp, messageResolver);
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
        (_) async => Success(_testUser),
      );

      final expected = [
        const SignUpLoading(),
        isA<SignUpSuccess>(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.signUp(
        email: 'test@test.com',
        password: 'password123',
        fullName: 'Test',
      );
    });

    test('emits [SignUpLoading, SignUpError] on failure', () async {
      when(() => signUp(any())).thenAnswer(
        (_) async => const Failure(EmailAlreadyExists()),
      );
      when(() => messageResolver.resolve(any())).thenReturn('Error message');

      final expected = [
        const SignUpLoading(),
        isA<SignUpError>(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.signUp(
        email: 'test@test.com',
        password: 'password123',
        fullName: 'Test',
      );
    });
  });
}
