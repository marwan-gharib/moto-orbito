import 'package:moto_orbito/core/error/api_result.dart';

import '../repositories/auth_repository.dart';

final class ResetPassword {
  ResetPassword(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call(EmailParams params) {
    return _repository.sendPasswordResetEmail(params);
  }
}
