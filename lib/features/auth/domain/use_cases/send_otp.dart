import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/utils/use_case.dart';

import '../repositories/auth_repository.dart';
import '../repositories/params/params.dart';

class SendOtp implements UseCase<void, EmailParams> {
  SendOtp(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResult<void>> call(EmailParams params) {
    return _repository.sendEmailOtp(params);
  }
}
