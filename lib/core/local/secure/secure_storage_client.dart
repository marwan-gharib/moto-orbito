abstract class SecureStorageClient {
  Future<void> saveValue(String key, String value);
  Future<String?> getValue(String key);
  Future<void> deleteValue(String key);
  Future<bool> hasValue(String key);
}
