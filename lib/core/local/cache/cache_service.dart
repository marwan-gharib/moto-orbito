abstract class CacheService {
  Future<bool> setData({required String key, required Object value});
  Object? get(String key);
  bool containsKey(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}
