import 'package:flutter_test/flutter_test.dart';
import 'package:moto_orbito/core/error/failure.dart';

void main() {
  group('AppFailure', () {
    test('NetworkFailure has correct messageKey', () {
      expect(const NetworkFailure().messageKey, 'errors.network');
    });
    test('ServerFailure has correct messageKey and statusCode', () {
      const failure = ServerFailure(statusCode: 500);
      expect(failure.messageKey, 'errors.server');
      expect(failure.statusCode, 500);
    });
    test('AuthFailure has correct messageKey', () {
      expect(const AuthFailure().messageKey, 'errors.auth');
    });
    test('NotFoundFailure has correct messageKey', () {
      expect(const NotFoundFailure().messageKey, 'errors.notFound');
    });
    test('PermissionFailure has correct messageKey', () {
      expect(const PermissionFailure().messageKey, 'errors.permission');
    });
    test('StorageFailure has correct messageKey', () {
      expect(const StorageFailure().messageKey, 'errors.storage');
    });
    test('UnexpectedFailure has correct messageKey', () {
      expect(const UnexpectedFailure().messageKey, 'errors.unexpected');
    });
  });
}
