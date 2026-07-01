import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/check_onboarding_complete.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/mark_onboarding_complete.dart';
import 'package:moto_orbito/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_cubit.dart';
import 'package:moto_orbito/features/onboarding/presentation/cubits/onboarding_cubit/onboarding_state.dart';

class MockCheckOnboardingComplete extends Mock
    implements CheckOnboardingComplete {}

class MockMarkOnboardingComplete extends Mock
    implements MarkOnboardingComplete {}

class MockFailureMessageResolver extends Mock
    implements FailureMessageResolver {}

void main() {
  late CheckOnboardingComplete checkUseCase;
  late MarkOnboardingComplete markUseCase;
  late FailureMessageResolver messageResolver;
  late OnboardingCubit cubit;

  setUpAll(() {
    registerFallbackValue(const NetworkFailure());
  });

  setUp(() {
    checkUseCase = MockCheckOnboardingComplete();
    markUseCase = MockMarkOnboardingComplete();
    messageResolver = MockFailureMessageResolver();
    cubit = OnboardingCubit(checkUseCase, markUseCase, messageResolver);
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

    test('emits loading then in progress at page 0 when onboarding is not done',
        () async {
      when(() => checkUseCase()).thenAnswer((_) async => const Success(false));

      await cubit.checkOnboardingStatus();

      expect(
        cubit.state,
        isA<OnboardingInProgress>().having(
          (s) => s.currentPage,
          'currentPage',
          0,
        ),
      );
    });

    test('emits loading then in progress at page 0 on failure', () async {
      when(() => checkUseCase())
          .thenAnswer((_) async => const Failure(StorageFailure()));

      await cubit.checkOnboardingStatus();

      expect(
        cubit.state,
        isA<OnboardingInProgress>().having(
          (s) => s.currentPage,
          'currentPage',
          0,
        ),
      );
    });
  });

  group('nextPage', () {
    test('advances from page 0 to page 1', () {
      cubit.setPage(0);

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
      cubit.setPage(1);

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
      cubit.setPage(2);

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
      when(() => messageResolver.resolve(any())).thenReturn('Error message');

      await cubit.completeOnboarding();

      expect(cubit.state, isA<OnboardingError>());
    });
  });
}
