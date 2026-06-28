import 'dart:developer' as developer;

abstract final class AppLogger {
  static bool _enabled = false;

  static const List<String> _sensitiveMarkers = [
    'password',
    'token',
    'jwt',
    'blood',
    'emergency',
    'contact',
  ];

  static bool get isEnabled => _enabled;

  static void init({required bool enabled}) {
    _enabled = enabled;
    info('AppLogger initialized');
  }

  static void debug(String message) => _log('DEBUG', message);

  static void info(String message) => _log('INFO', message);

  static void warning(String message) => _log('WARN', message);

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_enabled || _containsSensitiveData(message)) return;
    developer.log(
      '[$level] $message',
      name: 'MotoOrbito',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static bool _containsSensitiveData(String message) {
    final normalized = message.toLowerCase();
    return _sensitiveMarkers.any(normalized.contains);
  }
}
