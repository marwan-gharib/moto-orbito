import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/delete_account.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late DeleteAccount useCase;

  setUp(() {
    repository = MockAuthRepository();
    useCase = DeleteAccount(repository);
  });

  test('deletes account successfully', () async {
    when(repository.deleteAccount).thenAnswer(
      (_) async => const Success(null),
    );

    final result = await useCase();

    expect(result, isA<Success<void>>());
  });

  test('returns failure on error', () async {
    when(repository.deleteAccount).thenAnswer(
      (_) async => const Failure(ServerFailure()),
    );

    final result = await useCase();

    expect(result, isA<Failure<void>>());
    expect((result as Failure<void>).failure, isA<ServerFailure>());
  });
}
