import 'dart:typed_data';

import '../../constants/app_constants.dart';
import '../../error/api_result.dart';
import '../../error/failure.dart';
import '../../error/failure_mapper.dart';
import 'supabase_service.dart';


final class StorageService {
  const StorageService(this._supabaseService);

  final SupabaseService _supabaseService;

  Future<ApiResult<String>> uploadFile({
    required String bucket,
    required String path,
    required Uint8List bytes,
  }) async {
    if (bytes.length > AppConstants.maxUploadBytes) {
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
    } catch (error) {
      return Failure(FailureMapper.fromObject(error));
    }
  }

  Future<ApiResult<void>> deleteFile({
    required String bucket,
    required String path,
  }) async {
    try {
      await _supabaseService.client.storage.from(bucket).remove([path]);
      return const Success(null);
    } catch (error) {
      return Failure(FailureMapper.fromObject(error));
    }
  }
}
