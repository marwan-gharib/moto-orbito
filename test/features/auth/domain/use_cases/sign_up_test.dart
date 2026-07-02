import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_type.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/repositories/params/params.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/sign_up.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late SignUp useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = SignUp(repository);
  });

  final params = SignUpParams(
    email: 'test@test.com',
    password: 'password123',
    fullName: 'Test User',
    username: 'testuser',
  );

  final testUser = UserEntity(
    id: 'uid-1',
    email: 'test@test.com',
    fullName: 'Test User',
    username: 'testuser',
    createdAt: DateTime(2026),
  );

  test('signs up successfully', () async {
    when(() => repository.signUpWithEmailPassword(params)).thenAnswer(
      (_) async => Success(testUser),
    );

    final result = await useCase(params);

    expect(result, isA<Success<UserEntity>>());
  });

  test('returns failure when email already registered', () async {
    when(() => repository.signUpWithEmailPassword(params)).thenAnswer(
      (_) async => const Failure(EmailAlreadyExists()),
    );

    final result = await useCase(params);

    expect(result, isA<Failure<UserEntity>>());
    expect(
      (result as Failure<UserEntity>).failure.type,
      FailureType.emailAlreadyExists,
    );
  });

  test('returns failure on network error', () async {
    when(() => repository.signUpWithEmailPassword(params)).thenAnswer(
      (_) async => const Failure(NetworkFailure()),
    );

    final result = await useCase(params);

    expect(result, isA<Failure<UserEntity>>());
    expect(
      (result as Failure<UserEntity>).failure.type,
      FailureType.network,
    );
  });
}
