import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/send_otp.dart';
import '../../../domain/use_cases/verify_otp.dart';
import 'otp_state.dart';

final class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._sendOtp, this._verifyOtp, this._messageResolver)
      : super(const OtpInitial());

  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;
  final FailureMessageResolver _messageResolver;

  static const int maxResendAttempts = 3;
  int _resendCount = 0;

  Future<void> sendEmailOtp(String email) async {
    if (_resendCount >= maxResendAttempts) {
      emit(const OtpResendExhausted());
      return;
    }
    emit(const OtpSending());
    final result = await _sendOtp.email(EmailParams(email: email));
    result.fold(
      onFailure: (f) => emit(OtpError(_messageResolver.resolve(f))),
      onSuccess: (_) {
        _resendCount++;
        emit(OtpSent(
          resendAttemptsRemaining: maxResendAttempts - _resendCount,
        ));
      },
    );
  }

  Future<void> sendPhoneOtp(String phone) async {
    if (_resendCount >= maxResendAttempts) {
      emit(const OtpResendExhausted());
      return;
    }
    emit(const OtpSending());
    final result = await _sendOtp.phone(PhoneParams(phone: phone));
    result.fold(
      onFailure: (f) => emit(OtpError(_messageResolver.resolve(f))),
      onSuccess: (_) {
        _resendCount++;
        emit(OtpSent(
          resendAttemptsRemaining: maxResendAttempts - _resendCount,
        ));
      },
    );
  }

  Future<void> verifyEmailOtp(String email, String token) async {
    emit(const OtpVerifying());
    final result = await _verifyOtp.email(
      OtpVerifyParams(target: email, token: token, type: OtpType.email),
    );
    result.fold(
      onFailure: (f) => emit(OtpError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const OtpVerified()),
    );
  }

  Future<void> verifyPhoneOtp(String phone, String token) async {
    emit(const OtpVerifying());
    final result = await _verifyOtp.phone(
      OtpVerifyParams(target: phone, token: token, type: OtpType.sms),
    );
    result.fold(
      onFailure: (f) => emit(OtpError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const OtpVerified()),
    );
  }

  void resetResendCount() {
    _resendCount = 0;
  }
}
