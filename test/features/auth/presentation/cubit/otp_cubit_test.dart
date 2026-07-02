import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/features/auth/domain/repositories/params/params.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/send_otp.dart';
import 'package:moto_orbito/features/auth/domain/use_cases/verify_otp.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/otp_cubit/otp_cubit.dart';
import 'package:moto_orbito/features/auth/presentation/cubits/otp_cubit/otp_state.dart';

class MockSendOtp extends Mock implements SendOtp {}

class MockVerifyOtp extends Mock implements VerifyOtp {}

class MockFailureMessageResolver extends Mock
    implements FailureMessageResolver {}

void main() {
  late SendOtp sendOtp;
  late VerifyOtp verifyOtp;
  late FailureMessageResolver messageResolver;
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
    registerFallbackValue(const NetworkFailure());
  });

  setUp(() {
    sendOtp = MockSendOtp();
    verifyOtp = MockVerifyOtp();
    messageResolver = MockFailureMessageResolver();
    cubit = OtpCubit(sendOtp, verifyOtp, messageResolver);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is OtpInitial', () {
    expect(cubit.state, const OtpInitial());
  });

  group('sendEmailOtp', () {
    test('emits [OtpSending, OtpSent] on success', () async {
      when(() => sendOtp(any())).thenAnswer(
        (_) async => const Success(null),
      );

      final expected = [
        const OtpSending(),
        isA<OtpSent>(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.sendEmailOtp('test@test.com');
    });

    test('emits [OtpSending, OtpError] on failure', () async {
      when(() => sendOtp(any())).thenAnswer(
        (_) async => const Failure(NetworkFailure()),
      );
      when(() => messageResolver.resolve(any())).thenReturn('Error message');

      final expected = [
        const OtpSending(),
        isA<OtpError>(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.sendEmailOtp('test@test.com');
    });
  });

  group('verifyEmailOtp', () {
    test('emits [OtpVerifying, OtpVerified] on success', () async {
      when(() => verifyOtp(any())).thenAnswer(
        (_) async => const Success(null),
      );

      final expected = [
        const OtpVerifying(),
        const OtpVerified(),
      ];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.verifyEmailOtp('test@test.com', '123456');
    });
  });

  group('resendOtp - max 3 attempts', () {
    test('blocks after 3 resend attempts', () async {
      when(() => sendOtp(any())).thenAnswer(
        (_) async => const Success(null),
      );

      await cubit.sendEmailOtp('test@test.com');
      await cubit.sendEmailOtp('test@test.com');
      await cubit.sendEmailOtp('test@test.com');

      final expected = [const OtpResendExhausted()];
      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.sendEmailOtp('test@test.com');
    });
  });
}
