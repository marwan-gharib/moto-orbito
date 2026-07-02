import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/utils/use_case.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';
import '../repositories/params/params.dart';

class Login implements UseCase<UserEntity, LoginParams> {
  Login(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResult<UserEntity>> call(LoginParams params) {
    return _repository.signInWithEmailPassword(params);
  }
}
