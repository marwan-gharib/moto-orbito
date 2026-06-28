import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/send_otp.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/verify_otp.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/otp_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/cubit/otp_state.dart';

class MockSendOtp extends Mock implements SendOtp {}

class MockVerifyOtp extends Mock implements VerifyOtp {}

void main() {
  late SendOtp sendOtp;
  late VerifyOtp verifyOtp;
  late OtpCubit cubit;

  setUpAll(() {
    registerFallbackValue(const EmailParams(email: 'fallback@test.com'));
    registerFallbackValue(
      const OtpVerifyParams(
        target: 'fallback@test.com',
        token: '000000',
        type: OtpType.email,
      ),
    );
  });

  setUp(() {
    sendOtp = MockSendOtp();
    verifyOtp = MockVerifyOtp();
    cubit = OtpCubit(sendOtp, verifyOtp);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is OtpInitial', () {
    expect(cubit.state, const OtpInitial());
  });

  group('sendEmailOtp', () {
    test('emits [OtpSending, OtpSent] on success', () async {
      when(() => sendOtp.email(any())).thenAnswer(
        (_) async => const Success(null),
      );

      final states = await cubit.sendEmailOtp('test@test.com').toList();

      expect(states[0], const OtpSending());
      expect(states[1], isA<OtpSent>());
    });

    test('emits [OtpSending, OtpError] on failure', () async {
      when(() => sendOtp.email(any())).thenAnswer(
        (_) async => const Failure(NetworkFailure()),
      );

      final states = await cubit.sendEmailOtp('test@test.com').toList();

      expect(states[0], const OtpSending());
      expect(states[1], isA<OtpError>());
    });
  });

  group('verifyEmailOtp', () {
    test('emits [OtpVerifying, OtpVerified] on success', () async {
      when(() => verifyOtp.email(any())).thenAnswer(
        (_) async => const Success(null),
      );

      final states =
          await cubit.verifyEmailOtp('test@test.com', '123456').toList();

      expect(states[0], const OtpVerifying());
      expect(states[1], const OtpVerified());
    });
  });

  group('resendOtp - max 3 attempts', () {
    test('blocks after 3 resend attempts', () async {
      when(() => sendOtp.email(any())).thenAnswer(
        (_) async => const Success(null),
      );

      await cubit.sendEmailOtp('test@test.com').toList();
      await cubit.sendEmailOtp('test@test.com').toList();
      await cubit.sendEmailOtp('test@test.com').toList();

      final states = await cubit.sendEmailOtp('test@test.com').toList();

      expect(states, [const OtpResendExhausted()]);
    });
  });
}
