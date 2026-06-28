import 'package:dio/dio.dart';

import '../error/failure_mapper.dart';

final class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = FailureMapper.fromDioException(err);
    handler.next(err.copyWith(error: failure));
  }
}
