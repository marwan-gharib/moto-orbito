import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/utils/use_case.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetSession implements UseCaseNoInput<UserEntity?> {
  GetSession(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResult<UserEntity?>> call() {
    return _repository.getSession();
  }
}
