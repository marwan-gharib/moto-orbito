import 'package:moto_orbito/core/error/api_result.dart';

import '../repositories/auth_repository.dart';

final class DeleteAccount {
  DeleteAccount(this._repository);

  final AuthRepository _repository;

  Future<ApiResult<void>> call() {
    return _repository.deleteAccount();
  }
}
