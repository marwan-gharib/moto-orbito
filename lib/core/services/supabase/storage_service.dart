import 'dart:typed_data';

import '../../error/api_result.dart';
import '../../error/failure.dart';
import '../../error/failure_mapper.dart';
import 'supabase_service.dart';

abstract interface class StorageService {
  Future<ApiResult<String>> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
    required String mimeType,
  });

  Future<ApiResult<void>> deleteFile({
    required String bucket,
    required String path,
  });
}

final class StorageServiceImpl implements StorageService {
  StorageServiceImpl(this._supabaseService);

  static const int _maxUploadBytes = 5242880;

  final SupabaseService _supabaseService;

  @override
  Future<ApiResult<String>> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    if (bytes.length > _maxUploadBytes) {
      return const Failure(StorageFailure());
    }

    try {
      await _supabaseService.client.storage
          .from(bucket)
          .uploadBinary(path, bytes);
      final url = _supabaseService.client.storage
          .from(bucket)
          .getPublicUrl(path);
      return Success(url);
    } on Object catch (error) {
      return Failure(FailureMapper.fromObject(error));
    }
  }

  @override
  Future<ApiResult<void>> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await _supabaseService.client.storage.from(bucket).remove([path]);
      return const Success(null);
    } on Object catch (error) {
      return Failure(FailureMapper.fromObject(error));
    }
  }
}
