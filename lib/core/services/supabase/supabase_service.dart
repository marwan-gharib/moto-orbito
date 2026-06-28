import 'package:supabase_flutter/supabase_flutter.dart';

import '../../error/api_result.dart';
import '../../error/failure.dart';

abstract interface class SupabaseService {
  SupabaseClient get client;

  Future<ApiResult<void>> ping();
}

final class SupabaseServiceImpl implements SupabaseService {
  @override
  SupabaseClient get client => Supabase.instance.client;

  @override
  Future<ApiResult<void>> ping() async {
    try {
      await client.rpc<dynamic>('version');
      return const Success(null);
    } on Object {
      return const Failure(NetworkFailure());
    }
  }
}
