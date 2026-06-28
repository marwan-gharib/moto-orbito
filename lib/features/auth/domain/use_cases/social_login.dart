import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';

import '../repositories/auth_repository.dart';

class SocialLogin {
  SocialLogin(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<UserEntity>> google() {
    return _repository.signInWithGoogle();
  }

  Future<ApiResult<UserEntity>> facebook() {
    return _repository.signInWithFacebook();
  }
}
