import 'package:dio/dio.dart';

import 'failure.dart';

final class FailureMapper {
  const FailureMapper._();

  static AppFailure fromDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;
    if (statusCode == 401) return const AuthFailure();
    if (statusCode == 403) return const PermissionFailure();
    if (statusCode == 404) return const NotFoundFailure();
    if (statusCode != null && statusCode >= 500) {
      return ServerFailure(statusCode: statusCode);
    }

    return switch (exception.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.connectionError => const NetworkFailure(),
      DioExceptionType.badCertificate ||
      DioExceptionType.badResponse => ServerFailure(statusCode: statusCode),
      DioExceptionType.cancel ||
      DioExceptionType.unknown => const UnexpectedFailure(),
    };
  }

  static AppFailure fromObject(Object error) {
    if (error is AppFailure) return error;
    if (error is DioException) return fromDioException(error);
    return const UnexpectedFailure();
  }
}
