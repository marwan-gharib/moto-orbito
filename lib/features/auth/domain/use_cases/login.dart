import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

class Login {
  Login(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<UserEntity>> call(LoginParams params) {
    return _repository.signInWithEmailPassword(params);
  }
}
