import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';

import '../../domain/repositories/onboarding_local_repository.dart';

final class OnboardingLocalRepositoryImpl
    implements OnboardingLocalRepository {
  OnboardingLocalRepositoryImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const String _onboardingSeenKey = 'onboarding_seen';

  @override
  Future<ApiResult<bool>> isOnboardingComplete() async {
    try {
      final value = await _storage.read(key: _onboardingSeenKey);
      return Success(value == 'true');
    } on Object {
      return const Failure(StorageFailure());
    }
  }

  @override
  Future<ApiResult<void>> markOnboardingComplete() async {
    try {
      await _storage.write(key: _onboardingSeenKey, value: 'true');
      return const Success(null);
    } on Object {
      return const Failure(StorageFailure());
    }
  }
}
