import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/login.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late Login useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = Login(repository);
  });

  final params = LoginParams(
    email: 'test@test.com',
    password: 'password123',
  );

  final verifiedUser = UserEntity(
    id: 'uid-1',
    email: 'test@test.com',
    fullName: 'Test User',
    isEmailVerified: true,
    createdAt: DateTime(2026),
  );

  test('logs in successfully for verified user', () async {
    when(() => repository.signInWithEmailPassword(params)).thenAnswer(
      (_) async => Success(verifiedUser),
    );

    final result = await useCase(params);

    expect(result, isA<Success<UserEntity>>());
    expect((result as Success<UserEntity>).data.isEmailVerified, true);
  });

  test('returns failure for unverified user', () async {
    when(() => repository.signInWithEmailPassword(params)).thenAnswer(
      (_) async => const Failure(
        AuthFailure(messageKey: 'auth.emailNotVerified'),
      ),
    );

    final result = await useCase(params);

    expect(result, isA<Failure<UserEntity>>());
    expect((result as Failure<UserEntity>).failure.messageKey,
        'auth.emailNotVerified');
  });

  test('returns failure for invalid credentials', () async {
    when(() => repository.signInWithEmailPassword(params)).thenAnswer(
      (_) async => const Failure(
        AuthFailure(messageKey: 'auth.invalidCredentials'),
      ),
    );

    final result = await useCase(params);

    expect(result, isA<Failure<UserEntity>>());
    expect((result as Failure<UserEntity>).failure.messageKey,
        'auth.invalidCredentials');
  });
}
