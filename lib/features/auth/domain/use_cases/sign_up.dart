import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/utils/use_case.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';
import '../repositories/params/params.dart';

class SignUp implements UseCase<UserEntity, SignUpParams> {
  SignUp(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResult<UserEntity>> call(SignUpParams params) {
    return _repository.signUpWithEmailPassword(params);
  }
}
