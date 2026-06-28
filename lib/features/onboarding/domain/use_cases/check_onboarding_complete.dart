import 'package:moto_orbito/core/error/api_result.dart';

import '../repositories/onboarding_local_repository.dart';

class CheckOnboardingComplete {
  CheckOnboardingComplete(this._repository);

  final OnboardingLocalRepository _repository;

  Future<ApiResult<bool>> call() => _repository.isOnboardingComplete();
}
