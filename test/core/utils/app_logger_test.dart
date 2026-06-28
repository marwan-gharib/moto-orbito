import 'package:flutter_test/flutter_test.dart';
import 'package:moto_orbito/core/utils/app_logger.dart';

void main() {
  group('AppLogger', () {
    test('methods execute without error when enabled', () {
      AppLogger.init(enabled: true);
      AppLogger.debug('test');
      AppLogger.info('test');
      AppLogger.warning('test');
      AppLogger.error('test', error: Exception());
      expect(true, isTrue);
    });

    test('methods execute without error when disabled', () {
      AppLogger.init(enabled: false);
      AppLogger.debug('test');
      AppLogger.info('test');
      AppLogger.warning('test');
      AppLogger.error('test', error: Exception());
      expect(true, isTrue);
    });
  });
}
