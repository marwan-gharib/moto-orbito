import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moto_orbito/core/error/failure.dart';

import 'secure_storage_client.dart';

class FlutterSecureStorageClient implements SecureStorageClient {
  final FlutterSecureStorage _storage;

  FlutterSecureStorageClient(this._storage);

  @override
  Future<void> saveValue(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<String?> getValue(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<void> deleteValue(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<bool> hasValue(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      return false;
    }
  }
}
