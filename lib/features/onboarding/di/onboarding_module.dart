import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../data/repositories/onboarding_local_repository_impl.dart';
import '../domain/repositories/onboarding_local_repository.dart';
import '../domain/use_cases/check_onboarding_complete.dart';
import '../domain/use_cases/mark_onboarding_complete.dart';
import '../presentation/cubit/onboarding_cubit.dart';

void registerOnboardingModule() {
  final sl = GetIt.instance;

  if (!sl.isRegistered<OnboardingLocalRepository>()) {
    sl.registerLazySingleton<OnboardingLocalRepository>(
      () => OnboardingLocalRepositoryImpl(sl<FlutterSecureStorage>()),
    );
  }

  if (!sl.isRegistered<CheckOnboardingComplete>()) {
    sl.registerLazySingleton<CheckOnboardingComplete>(
      () => CheckOnboardingComplete(sl<OnboardingLocalRepository>()),
    );
  }

  if (!sl.isRegistered<MarkOnboardingComplete>()) {
    sl.registerLazySingleton<MarkOnboardingComplete>(
      () => MarkOnboardingComplete(sl<OnboardingLocalRepository>()),
    );
  }

  if (!sl.isRegistered<OnboardingCubit>()) {
    sl.registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        sl<CheckOnboardingComplete>(),
        sl<MarkOnboardingComplete>(),
      ),
    );
  }
}
