import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/login.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/social_login.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/login_cubit/login_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/login_cubit/login_state.dart';

class MockLogin extends Mock implements Login {}

class MockSocialLogin extends Mock implements SocialLogin {}

class MockFailureMessageResolver extends Mock
    implements FailureMessageResolver {}

final _testUser = UserEntity(
  id: 'uid-1',
  email: 'test@test.com',
  fullName: 'Test',
  createdAt: DateTime(2026),
);

void main() {
  late Login login;
  late SocialLogin socialLogin;
  late FailureMessageResolver messageResolver;
  late LoginCubit cubit;

  setUpAll(() {
    registerFallbackValue(
      LoginParams(email: 'fallback@test.com', password: 'fallback123'),
    );
    registerFallbackValue(const NetworkFailure());
  });

  setUp(() {
    login = MockLogin();
    socialLogin = MockSocialLogin();
    messageResolver = MockFailureMessageResolver();
    cubit = LoginCubit(login, socialLogin, messageResolver);
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
        (_) async => Success(_testUser),
      );

      final expected = [
        const LoginLoading(),
        isA<LoginSuccess>(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.login(email: 'test@test.com', password: 'password123');
    });

    test('emits [LoginLoading, LoginError] on failure', () async {
      when(() => login(any())).thenAnswer(
        (_) async => const Failure(InvalidCredentials()),
      );
      when(() => messageResolver.resolve(any())).thenReturn('Error message');

      final expected = [
        const LoginLoading(),
        isA<LoginError>(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.login(email: 'test@test.com', password: 'wrong');
    });
  });
}
