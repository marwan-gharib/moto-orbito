import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/onboarding/domain/repositories/onboarding_local_repository.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/check_onboarding_complete.dart';

class MockOnboardingLocalRepository extends Mock
    implements OnboardingLocalRepository {}

void main() {
  late OnboardingLocalRepository repository;
  late CheckOnboardingComplete useCase;

  setUp(() {
    repository = MockOnboardingLocalRepository();
    useCase = CheckOnboardingComplete(repository);
  });

  test('returns true when onboarding is complete', () async {
    when(repository.isOnboardingComplete).thenAnswer(
      (_) async => const Success(true),
    );

    final result = await useCase();

    expect(result, isA<Success<bool>>());
    expect((result as Success<bool>).data, true);
  });

  test('returns false when onboarding is not complete', () async {
    when(repository.isOnboardingComplete).thenAnswer(
      (_) async => const Success(false),
    );

    final result = await useCase();

    expect(result, isA<Success<bool>>());
    expect((result as Success<bool>).data, false);
  });

  test('forwards failure from repository', () async {
    when(repository.isOnboardingComplete).thenAnswer(
      (_) async => const Failure(StorageFailure()),
    );

    final result = await useCase();

    expect(result, isA<Failure<bool>>());
    expect((result as Failure<bool>).failure, isA<StorageFailure>());
  });
}
