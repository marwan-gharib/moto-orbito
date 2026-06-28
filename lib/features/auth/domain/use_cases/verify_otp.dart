import 'package:moto_orbito/core/error/api_result.dart';

import '../repositories/auth_repository.dart';

class VerifyOtp {
  VerifyOtp(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> email(OtpVerifyParams params) {
    return _repository.verifyEmailOtp(params);
  }

  Future<ApiResult<void>> phone(OtpVerifyParams params) {
    return _repository.verifyPhoneOtp(params);
  }
}
