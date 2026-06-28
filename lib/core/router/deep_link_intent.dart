import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class DeepLinkIntent {
  const DeepLinkIntent({required this.uri});

  final String uri;
}

final class DeepLinkIntentStore {
  DeepLinkIntentStore(this._storage);

  static const String _key = 'pending_deep_link';

  final FlutterSecureStorage _storage;

  Future<void> save(String uri) => _storage.write(key: _key, value: uri);

  Future<DeepLinkIntent?> read() async {
    final uri = await _storage.read(key: _key);
    return uri == null ? null : DeepLinkIntent(uri: uri);
  }

  Future<void> clear() => _storage.delete(key: _key);
}
