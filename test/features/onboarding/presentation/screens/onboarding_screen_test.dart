import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/i18n/strings.g.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/check_onboarding_complete.dart';
import 'package:moto_orbito/features/onboarding/domain/use_cases/mark_onboarding_complete.dart';
import 'package:moto_orbito/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:moto_orbito/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:moto_orbito/features/onboarding/presentation/screens/onboarding_screen.dart';

class MockCheckOnboardingComplete extends Mock
    implements CheckOnboardingComplete {}

class MockMarkOnboardingComplete extends Mock
    implements MarkOnboardingComplete {}

Widget createTestWidget(OnboardingCubit cubit) {
  final router = GoRouter(
    initialLocation: AppRoute.onboarding,
    routes: [
      GoRoute(
        path: AppRoute.onboarding,
        builder: (_, __) => BlocProvider<OnboardingCubit>.value(
          value: cubit,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.welcome,
        builder: (_, __) => const SizedBox.shrink(),
      ),
    ],
  );
  return MaterialApp.router(routerConfig: router);
}

void main() {
  late CheckOnboardingComplete checkUseCase;
  late MarkOnboardingComplete markUseCase;
  late OnboardingCubit cubit;

  setUp(() {
    LocaleSettings.setLocaleSync(AppLocale.ar);
    checkUseCase = MockCheckOnboardingComplete();
    markUseCase = MockMarkOnboardingComplete();
    cubit = OnboardingCubit(checkUseCase, markUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  testWidgets('shows onboarding slides and page indicators', (tester) async {
    when(() => checkUseCase()).thenAnswer((_) async => const Success(false));

    cubit.emit(const OnboardingInProgress(currentPage: 0));
    await tester.pumpWidget(createTestWidget(cubit));
    await tester.pumpAndSettle();

    expect(find.text('اركب معاً'), findsOneWidget);
  });

  testWidgets('skip button navigates to next screen', (tester) async {
    when(() => checkUseCase()).thenAnswer((_) async => const Success(false));
    when(() => markUseCase()).thenAnswer((_) async => const Success(null));

    cubit.emit(const OnboardingInProgress(currentPage: 0));
    await tester.pumpWidget(createTestWidget(cubit));
    await tester.pumpAndSettle();

    expect(find.text('تخطي'), findsOneWidget);

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();

    expect(cubit.state, isA<OnboardingComplete>());
  });

  testWidgets('shows error state when mark onboarding fails', (tester) async {
    when(() => checkUseCase()).thenAnswer((_) async => const Success(false));
    when(() => markUseCase())
        .thenAnswer((_) async => const Failure(NetworkFailure()));

    cubit.emit(const OnboardingInProgress(currentPage: 0));
    await tester.pumpWidget(createTestWidget(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();

    expect(find.text('إعادة المحاولة'), findsOneWidget);
  });

  testWidgets('retry button retries complete onboarding on error',
      (tester) async {
    when(() => checkUseCase()).thenAnswer((_) async => const Success(false));
    when(() => markUseCase())
        .thenAnswer((_) async => const Failure(NetworkFailure()));

    cubit.emit(const OnboardingInProgress(currentPage: 0));
    await tester.pumpWidget(createTestWidget(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('تخطي'));
    await tester.pumpAndSettle();

    expect(cubit.state, isA<OnboardingError>());

    when(() => markUseCase()).thenAnswer((_) async => const Success(null));

    await tester.tap(find.text('إعادة المحاولة'));
    await tester.pumpAndSettle();

    expect(cubit.state, isA<OnboardingComplete>());
  });
}
