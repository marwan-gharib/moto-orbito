import 'package:moto_orbito/core/error/api_result.dart';

abstract interface class OnboardingLocalRepository {
  Future<ApiResult<bool>> isOnboardingComplete();
  Future<ApiResult<void>> markOnboardingComplete();
}
