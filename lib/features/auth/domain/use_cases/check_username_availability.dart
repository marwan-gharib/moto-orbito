import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/utils/use_case.dart';

import '../repositories/auth_repository.dart';
import '../repositories/params/params.dart';

class CheckUsernameAvailability implements UseCase<bool, UsernameCheckParams> {
  CheckUsernameAvailability(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResult<bool>> call(UsernameCheckParams params) {
    return _repository.checkUsernameAvailability(params);
  }
}
