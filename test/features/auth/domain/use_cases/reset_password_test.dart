import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/repositories/params/params.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/reset_password.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late ResetPassword useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = ResetPassword(repository);
  });

  test('sends password reset email successfully', () async {
    final params = const EmailParams(email: 'test@test.com');
    when(() => repository.sendPasswordResetEmail(params)).thenAnswer(
      (_) async => const Success(null),
    );

    final result = await useCase(params);

    expect(result, isA<Success<void>>());
  });

  test('always returns success to prevent enumeration', () async {
    final params = const EmailParams(email: 'nonexistent@test.com');
    when(() => repository.sendPasswordResetEmail(params)).thenAnswer(
      (_) async => const Success(null),
    );

    final result = await useCase(params);

    expect(result, isA<Success<void>>());
  });
}
