import 'package:flutter_test/flutter_test.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_type.dart';

void main() {
  group('AppFailure', () {
    test('NetworkFailure has correct type', () {
      expect(const NetworkFailure().type, FailureType.network);
    });
    test('ServerFailure has correct type and statusCode', () {
      const failure = ServerFailure(statusCode: 500);
      expect(failure.type, FailureType.server);
      expect(failure.statusCode, 500);
    });
    test('AuthFailure has correct type', () {
      expect(const AuthFailure().type, FailureType.auth);
    });
    test('EmailAlreadyExists has correct type', () {
      expect(const EmailAlreadyExists().type, FailureType.emailAlreadyExists);
    });
    test('EmailNotVerified has correct type', () {
      expect(const EmailNotVerified().type, FailureType.emailNotVerified);
    });
    test('InvalidCredentials has correct type', () {
      expect(const InvalidCredentials().type, FailureType.invalidCredentials);
    });

    test('EmailUnverifiedExists has correct type', () {
      expect(const EmailUnverifiedExists().type, FailureType.emailUnverifiedExists);
    });
    test('OtpExpired has correct type', () {
      expect(const OtpExpired().type, FailureType.otpExpired);
    });
    test('InvalidOtp has correct type', () {
      expect(const InvalidOtp().type, FailureType.invalidOtp);
    });
    test('NotFoundFailure has correct type', () {
      expect(const NotFoundFailure().type, FailureType.notFound);
    });
    test('PermissionFailure has correct type', () {
      expect(const PermissionFailure().type, FailureType.permission);
    });
    test('StorageFailure has correct type', () {
      expect(const StorageFailure().type, FailureType.storage);
    });
    test('UnexpectedFailure has correct type', () {
      expect(const UnexpectedFailure().type, FailureType.unexpected);
    });
  });
}
