import '../error/api_result.dart';

abstract interface class BaseApiClient {
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  });

  Future<ApiResult<T>> post<T>(
    String path, {
    required Map<String, dynamic> body,
    required T Function(dynamic json) fromJson,
  });

  Future<ApiResult<T>> put<T>(
    String path, {
    required Map<String, dynamic> body,
    required T Function(dynamic json) fromJson,
  });

  Future<ApiResult<void>> delete(String path);
}
