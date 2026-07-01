import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_type.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/send_otp.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/verify_otp.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  group('SendOtp', () {
    late SendOtp sendOtp;

    setUp(() {
      sendOtp = SendOtp(repository);
    });

    test('sends email OTP successfully', () async {
      final params = const EmailParams(email: 'test@test.com');
      when(() => repository.sendEmailOtp(params)).thenAnswer(
        (_) async => const Success(null),
      );

      final result = await sendOtp.email(params);

      expect(result, isA<Success<void>>());
    });

    test('returns failure when sending email OTP fails', () async {
      final params = const EmailParams(email: 'test@test.com');
      when(() => repository.sendEmailOtp(params)).thenAnswer(
        (_) async => const Failure(NetworkFailure()),
      );

      final result = await sendOtp.email(params);

      expect(result, isA<Failure<void>>());
    });

    test('sends phone OTP successfully', () async {
      final params = const PhoneParams(phone: '+971501234567');
      when(() => repository.sendPhoneOtp(params)).thenAnswer(
        (_) async => const Success(null),
      );

      final result = await sendOtp.phone(params);

      expect(result, isA<Success<void>>());
    });
  });

  group('VerifyOtp', () {
    late VerifyOtp verifyOtp;

    setUp(() {
      verifyOtp = VerifyOtp(repository);
    });

    test('verifies email OTP successfully', () async {
      final params = const OtpVerifyParams(
        target: 'test@test.com',
        token: '123456',
        type: OtpType.email,
      );
      when(() => repository.verifyEmailOtp(params)).thenAnswer(
        (_) async => const Success(null),
      );

      final result = await verifyOtp.email(params);

      expect(result, isA<Success<void>>());
    });

    test('returns failure for invalid OTP', () async {
      final params = const OtpVerifyParams(
        target: 'test@test.com',
        token: 'wrong',
        type: OtpType.email,
      );
      when(() => repository.verifyEmailOtp(params)).thenAnswer(
        (_) async => const Failure(InvalidOtp()),
      );

      final result = await verifyOtp.email(params);

      expect(result, isA<Failure<void>>());
      expect(
        (result as Failure<void>).failure.type,
        FailureType.invalidOtp,
      );
    });
  });
}
