import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/onboarding/domain/repositories/onboarding_local_repository.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/mark_onboarding_complete.dart';

class MockOnboardingLocalRepository extends Mock
    implements OnboardingLocalRepository {}

void main() {
  late OnboardingLocalRepository repository;
  late MarkOnboardingComplete useCase;

  setUp(() {
    repository = MockOnboardingLocalRepository();
    useCase = MarkOnboardingComplete(repository);
  });

  test('marks onboarding as complete successfully', () async {
    when(repository.markOnboardingComplete).thenAnswer(
      (_) async => const Success(null),
    );

    final result = await useCase();

    expect(result, isA<Success<void>>());
  });

  test('forwards failure from repository', () async {
    when(repository.markOnboardingComplete).thenAnswer(
      (_) async => const Failure(StorageFailure()),
    );

    final result = await useCase();

    expect(result, isA<Failure<void>>());
    expect((result as Failure<void>).failure, isA<StorageFailure>());
  });
}
