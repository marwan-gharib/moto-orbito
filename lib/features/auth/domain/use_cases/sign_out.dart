import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/utils/use_case.dart';

import '../repositories/auth_repository.dart';

class SignOutUseCase implements UseCaseNoInput<void> {
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<ApiResult<void>> call() {
    return _repository.signOut();
  }
}
