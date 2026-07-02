import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/params/params.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/check_username_availability.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/sign_up.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/sign_up_cubit/sign_up_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/sign_up_cubit/sign_up_state.dart';

class MockSignUp extends Mock implements SignUp {}

class MockCheckUsernameAvailability extends Mock
    implements CheckUsernameAvailability {}

class MockFailureMessageResolver extends Mock
    implements FailureMessageResolver {}

final _testUser = UserEntity(
  id: 'uid-1',
  email: 'test@test.com',
  fullName: 'Test',
  username: 'testuser',
  createdAt: DateTime(2026),
);

void main() {
  late SignUp signUp;
  late CheckUsernameAvailability checkUsername;
  late FailureMessageResolver messageResolver;
  late SignUpCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      SignUpParams(
        email: 'fallback@test.com',
        password: 'fallback123',
        fullName: 'Fallback',
        username: 'fallback',
      ),
    );
    registerFallbackValue(const NetworkFailure());
    registerFallbackValue(const UsernameCheckParams('fallback'));
  });

  setUp(() {
    signUp = MockSignUp();
    checkUsername = MockCheckUsernameAvailability();
    messageResolver = MockFailureMessageResolver();
    cubit = SignUpCubit(signUp, checkUsername, messageResolver);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is SignUpInitial', () {
    expect(cubit.state, const SignUpInitial());
  });

  group('signUp', () {
    test('emits [SignUpLoading, SignUpSuccess] when username available', () async {
      when(() => checkUsername(any())).thenAnswer(
        (_) async => const Success(true),
      );
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
        username: 'testuser',
      );
    });

    test('emits [SignUpLoading, SignUpUsernameTaken] when username taken', () async {
      when(() => checkUsername(any())).thenAnswer(
        (_) async => const Success(false),
      );

      final expected = [
        const SignUpLoading(),
        const SignUpUsernameTaken(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.signUp(
        email: 'test@test.com',
        password: 'password123',
        fullName: 'Test',
        username: 'takenuser',
      );
    });

    test('emits [SignUpLoading, SignUpError] on signup failure', () async {
      when(() => checkUsername(any())).thenAnswer(
        (_) async => const Success(true),
      );
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
        username: 'testuser',
      );
    });

    test('emits [SignUpLoading, SignUpEmailUnverified] on unverified existing email', () async {
      when(() => checkUsername(any())).thenAnswer(
        (_) async => const Success(true),
      );
      when(() => signUp(any())).thenAnswer(
        (_) async => const Failure(EmailUnverifiedExists()),
      );

      final expected = [
        const SignUpLoading(),
        const SignUpEmailUnverified(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.signUp(
        email: 'test@test.com',
        password: 'password123',
        fullName: 'Test',
        username: 'testuser',
      );
    });
  });

  group('resetState', () {
    test('resets to initial state', () async {
      cubit.resetState();

      expect(cubit.state, const SignUpInitial());
    });
  });
}
