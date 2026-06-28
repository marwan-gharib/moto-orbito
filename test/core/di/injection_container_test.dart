import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:moto_orbito/core/di/injection_container.dart';
import 'package:moto_orbito/core/network/base_api_client.dart';
import 'package:moto_orbito/core/services/ai/ai_service.dart';
import 'package:moto_orbito/core/services/fcm/fcm_service.dart';
import 'package:moto_orbito/core/services/supabase/realtime_service.dart';
import 'package:moto_orbito/core/services/supabase/storage_service.dart';
import 'package:moto_orbito/core/services/supabase/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('InjectionContainer', () {
    test('all core singletons resolve', () async {
      SharedPreferences.setMockInitialValues({});
      await initDependencies(
        supabaseUrl: 'http://localhost',
        supabaseAnonKey: 'key',
      );

      expect(GetIt.instance.isRegistered<BaseApiClient>(), isTrue);
      expect(GetIt.instance.isRegistered<SupabaseService>(), isTrue);
      expect(GetIt.instance.isRegistered<RealtimeService>(), isTrue);
      expect(GetIt.instance.isRegistered<StorageService>(), isTrue);
      expect(GetIt.instance.isRegistered<FcmService>(), isTrue);
      expect(GetIt.instance.isRegistered<AiService>(), isTrue);
    });
  });
}
