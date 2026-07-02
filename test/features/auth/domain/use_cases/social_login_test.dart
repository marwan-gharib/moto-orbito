import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/social_login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late SocialLogin useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SocialLogin(repository);
  });

  final googleUser = UserEntity(
    id: 'uid-1',
    email: 'test@gmail.com',
    fullName: 'Test User',
    username: 'googleuser',
    createdAt: DateTime(2026),
  );

  final fbUser = UserEntity(
    id: 'uid-2',
    email: 'test@fb.com',
    fullName: 'FB User',
    username: 'fbuser',
    createdAt: DateTime(2026),
  );

  test('sign in with Google returns user entity', () async {
    when(repository.signInWithGoogle).thenAnswer(
      (_) async => Success(googleUser),
    );

    final result = await useCase.google();

    expect(result, isA<Success<UserEntity>>());
    expect((result as Success<UserEntity>).data.email, 'test@gmail.com');
  });

  test('sign in with Google returns failure on error', () async {
    when(repository.signInWithGoogle).thenAnswer(
      (_) async => const Failure(AuthFailure()),
    );

    final result = await useCase.google();

    expect(result, isA<Failure<UserEntity>>());
  });

  test('sign in with Facebook returns user entity', () async {
    when(repository.signInWithFacebook).thenAnswer(
      (_) async => Success(fbUser),
    );

    final result = await useCase.facebook();

    expect(result, isA<Success<UserEntity>>());
    expect((result as Success<UserEntity>).data.email, 'test@fb.com');
  });

  test('sign in with Facebook returns failure on error', () async {
    when(repository.signInWithFacebook).thenAnswer(
      (_) async => const Failure(AuthFailure()),
    );

    final result = await useCase.facebook();

    expect(result, isA<Failure<UserEntity>>());
  });
}
