import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moto_orbito/core/network/base_api_client.dart';

import '../error/api_result.dart';
import '../error/failure.dart';
import '../error/failure_mapper.dart';
import 'auth_interceptor.dart';
import 'error_interceptor.dart';
import 'logging_interceptor.dart';

final class DioClient implements BaseApiClient {
  DioClient(
    this._dio,
    this._connectivity, {
    required FlutterSecureStorage storage,
  }) {
    _dio.interceptors.addAll([
      AuthInterceptor(storage),
      LoggingInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  final Dio _dio;
  final Connectivity _connectivity;

  @override
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    required T Function(dynamic json) fromJson,
  }) {
    return _request(() async {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParams,
      );
      return fromJson(response.data);
    });
  }

  @override
  Future<ApiResult<T>> post<T>(
    String path, {
    required Map<String, dynamic> body,
    required T Function(dynamic json) fromJson,
  }) {
    return _request(() async {
      final response = await _dio.post<dynamic>(path, data: body);
      return fromJson(response.data);
    });
  }

  @override
  Future<ApiResult<T>> put<T>(
    String path, {
    required Map<String, dynamic> body,
    required T Function(dynamic json) fromJson,
  }) {
    return _request(() async {
      final response = await _dio.put<dynamic>(path, data: body);
      return fromJson(response.data);
    });
  }

  @override
  Future<ApiResult<void>> delete(String path) {
    return _request(() async {
      await _dio.delete<dynamic>(path);
    });
  }

  Future<ApiResult<T>> _request<T>(Future<T> Function() request) async {
    final connectivity = await _connectivity.checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      return const Failure(NetworkFailure());
    }

    try {
      return Success(await request());
    } on DioException catch (error) {
      return Failure(FailureMapper.fromObject(error.error ?? error));
    } on Object catch (error) {
      return Failure(FailureMapper.fromObject(error));
    }
  }
}
