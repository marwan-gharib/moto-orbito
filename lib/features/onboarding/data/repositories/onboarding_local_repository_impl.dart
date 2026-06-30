import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/local/cache/cache_service.dart';

import '../../domain/repositories/onboarding_local_repository.dart';

final class OnboardingLocalRepositoryImpl implements OnboardingLocalRepository {
  OnboardingLocalRepositoryImpl(this._cacheService);

  final CacheService _cacheService;

  static const String _onboardingCacheKey = 'onboarding_seen_cache';

  @override
  Future<ApiResult<bool>> isOnboardingComplete() async {
    try {
      final cachedValue = _cacheService.get(_onboardingCacheKey);
      return Success(cachedValue == true);
    } on Object {
      return const Failure(CacheFailure());
    }
  }

  @override
  Future<ApiResult<void>> markOnboardingComplete() async {
    try {
      await _cacheService.setData(key: _onboardingCacheKey, value: true);
      return const Success(null);
    } on Object {
      return const Failure(CacheFailure());
    }
  }
}
