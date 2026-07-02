import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_type.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/repositories/params/params.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/check_username_availability.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late CheckUsernameAvailability useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = CheckUsernameAvailability(repository);
  });

  final params = UsernameCheckParams('newuser');

  test('returns true when username is available', () async {
    when(() => repository.checkUsernameAvailability(params)).thenAnswer(
      (_) async => const Success(true),
    );

    final result = await useCase(params);

    expect(result, isA<Success<bool>>());
    expect((result as Success<bool>).data, true);
  });

  test('returns false when username is taken', () async {
    when(() => repository.checkUsernameAvailability(params)).thenAnswer(
      (_) async => const Success(false),
    );

    final result = await useCase(params);

    expect(result, isA<Success<bool>>());
    expect((result as Success<bool>).data, false);
  });

  test('returns failure on error', () async {
    when(() => repository.checkUsernameAvailability(params)).thenAnswer(
      (_) async => const Failure(NetworkFailure()),
    );

    final result = await useCase(params);

    expect(result, isA<Failure<bool>>());
    expect(
      (result as Failure<bool>).failure.type,
      FailureType.network,
    );
  });
}
