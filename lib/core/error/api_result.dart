import 'failure.dart';

sealed class ApiResult<T> {
  const ApiResult();
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends ApiResult<T> {
  const Failure(this.failure);

  final AppFailure failure;
}
