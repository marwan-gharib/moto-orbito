import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/utils/use_case.dart';

import '../repositories/onboarding_local_repository.dart';

class MarkOnboardingComplete implements UseCaseNoInput<void> {
  const MarkOnboardingComplete(this._repository);

  final OnboardingLocalRepository _repository;

  @override
  Future<ApiResult<void>> call() => _repository.markOnboardingComplete();
}
