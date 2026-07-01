import 'failure.dart';

sealed class ApiResult<T> {
  const ApiResult();

  R fold<R>({
    required R Function(AppFailure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    switch (this) {
      case Success(data: final data):
        return onSuccess(data);
      case Failure(failure: final failure):
        return onFailure(failure);
    }
  }
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends ApiResult<T> {
  const Failure(this.failure);

  final AppFailure failure;
}
