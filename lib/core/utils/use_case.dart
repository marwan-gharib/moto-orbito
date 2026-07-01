import '../error/api_result.dart';

/// UseCase requiring input parameters.
abstract interface class UseCase<Output, Input> {
  Future<ApiResult<Output>> call([Input? input]);
}

/// UseCase requiring no input parameters.
abstract interface class UseCaseNoInput<Output> {
  Future<ApiResult<Output>> call();
}
