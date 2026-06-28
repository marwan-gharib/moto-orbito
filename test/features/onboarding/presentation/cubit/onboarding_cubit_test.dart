import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/check_onboarding_complete.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/mark_onboarding_complete.dart';
import 'package:moto_orbito/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:moto_orbito/features/onboarding/presentation/cubit/onboarding_state.dart';

class MockCheckOnboardingComplete extends Mock
    implements CheckOnboardingComplete {}

class MockMarkOnboardingComplete extends Mock
    implements MarkOnboardingComplete {}

void main() {
  late CheckOnboardingComplete checkUseCase;
  late MarkOnboardingComplete markUseCase;
  late OnboardingCubit cubit;

  setUp(() {
    checkUseCase = MockCheckOnboardingComplete();
    markUseCase = MockMarkOnboardingComplete();
    cubit = OnboardingCubit(checkUseCase, markUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is OnboardingInitial', () {
    expect(cubit.state, const OnboardingInitial());
  });

  group('checkOnboardingStatus', () {
    test('emits loading then complete when onboarding is already done',
        () async {
      when(() => checkUseCase()).thenAnswer((_) async => const Success(true));

      await cubit.checkOnboardingStatus();

      expect(cubit.state, const OnboardingComplete());
    });

    test('emits loading then initial when onboarding is not done', () async {
      when(() => checkUseCase()).thenAnswer((_) async => const Success(false));

      await cubit.checkOnboardingStatus();

      expect(cubit.state, const OnboardingInitial());
    });

    test('emits loading then initial on failure', () async {
      when(() => checkUseCase())
          .thenAnswer((_) async => const Failure(StorageFailure()));

      await cubit.checkOnboardingStatus();

      expect(cubit.state, const OnboardingInitial());
    });
  });

  group('nextPage', () {
    test('advances from page 0 to page 1', () {
      cubit.emit(const OnboardingInProgress(currentPage: 0));

      cubit.nextPage();

      expect(
        cubit.state,
        isA<OnboardingInProgress>().having(
          (s) => s.currentPage,
          'currentPage',
          1,
        ),
      );
    });

    test('advances from page 1 to page 2', () {
      cubit.emit(const OnboardingInProgress(currentPage: 1));

      cubit.nextPage();

      expect(
        cubit.state,
        isA<OnboardingInProgress>().having(
          (s) => s.currentPage,
          'currentPage',
          2,
        ),
      );
    });

    test('does not advance beyond last page', () {
      cubit.emit(const OnboardingInProgress(currentPage: 2));

      cubit.nextPage();

      expect(
        cubit.state,
        isA<OnboardingInProgress>().having(
          (s) => s.currentPage,
          'currentPage',
          2,
        ),
      );
    });
  });

  group('completeOnboarding', () {
    test('emits loading then complete on success', () async {
      when(() => markUseCase()).thenAnswer((_) async => const Success(null));

      await cubit.completeOnboarding();

      expect(cubit.state, const OnboardingComplete());
    });

    test('emits loading then error on failure', () async {
      when(() => markUseCase())
          .thenAnswer((_) async => const Failure(NetworkFailure()));

      await cubit.completeOnboarding();

      expect(cubit.state, isA<OnboardingError>());
    });
  });
}
