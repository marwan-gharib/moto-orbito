import 'package:moto_orbito/core/error/api_result.dart';

import '../repositories/auth_repository.dart';

class SendOtp {
  SendOtp(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> email(EmailParams params) {
    return _repository.sendEmailOtp(params);
  }

  Future<ApiResult<void>> phone(PhoneParams params) {
    return _repository.sendPhoneOtp(params);
  }
}
