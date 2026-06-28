import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/app_links.dart';
import '../../error/api_result.dart';
import '../../error/failure.dart';

final class SupabaseService {
  const SupabaseService();

  SupabaseClient get client => Supabase.instance.client;

  Future<ApiResult<void>> ping() async {
    try {
      await client.rpc<dynamic>(AppLinks.version);
      return const Success(null);
    } on Object {
      return const Failure(NetworkFailure());
    }
  }
}
