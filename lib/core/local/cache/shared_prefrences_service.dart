import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/local/cache/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends CacheService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  @override
  Future<bool> setData({required String key, required Object value}) async {
    try {
      if (value is String) {
        return await _prefs.setString(key, value);
      } else if (value is bool) {
        return await _prefs.setBool(key, value);
      } else if (value is int) {
        return await _prefs.setInt(key, value);
      } else if (value is double) {
        return await _prefs.setDouble(key, value);
      } else {
        throw StorageFailure();
      }
    } catch (e) {
      throw StorageFailure();
    }
  }

  @override
  Object? get(String key) {
    try {
      return _prefs.get(key);
    } catch (e) {
      throw StorageFailure();
    }
  }

  @override
  bool containsKey(String key) {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      throw StorageFailure();
    }
  }

  @override
  Future<bool> remove(String key) {
    try {
      return _prefs.remove(key);
    } catch (e) {
      throw StorageFailure();
    }
  }

  @override
  Future<bool> clear() {
    try {
      return _prefs.clear();
    } catch (e) {
      throw StorageFailure();
    }
  }
}
