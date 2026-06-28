import 'package:moto_orbito/core/error/api_result.dart';

import '../repositories/onboarding_local_repository.dart';

class MarkOnboardingComplete {
  MarkOnboardingComplete(this._repository);

  final OnboardingLocalRepository _repository;

  Future<ApiResult<void>> call() => _repository.markOnboardingComplete();
}
