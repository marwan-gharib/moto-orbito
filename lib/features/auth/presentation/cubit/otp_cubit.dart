import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/send_otp.dart';
import '../../domain/use_cases/verify_otp.dart';
import 'otp_state.dart';

final class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._sendOtp, this._verifyOtp) : super(const OtpInitial());

  final SendOtp _sendOtp;
  final VerifyOtp _verifyOtp;

  static const int maxResendAttempts = 3;
  int _resendCount = 0;

  Future<void> sendEmailOtp(String email) async {
    if (_resendCount >= maxResendAttempts) {
      emit(const OtpResendExhausted());
      return;
    }
    emit(const OtpSending());
    final result = await _sendOtp.email(EmailParams(email: email));
    switch (result) {
      case Success():
        _resendCount++;
        emit(OtpSent(
          resendAttemptsRemaining: maxResendAttempts - _resendCount,
        ));
      case Failure(failure: final f):
        emit(OtpError(f.messageKey));
    }
  }

  Future<void> sendPhoneOtp(String phone) async {
    if (_resendCount >= maxResendAttempts) {
      emit(const OtpResendExhausted());
      return;
    }
    emit(const OtpSending());
    final result = await _sendOtp.phone(PhoneParams(phone: phone));
    switch (result) {
      case Success():
        _resendCount++;
        emit(OtpSent(
          resendAttemptsRemaining: maxResendAttempts - _resendCount,
        ));
      case Failure(failure: final f):
        emit(OtpError(f.messageKey));
    }
  }

  Future<void> verifyEmailOtp(String email, String token) async {
    emit(const OtpVerifying());
    final result = await _verifyOtp.email(
      OtpVerifyParams(target: email, token: token, type: OtpType.email),
    );
    switch (result) {
      case Success():
        emit(const OtpVerified());
      case Failure(failure: final f):
        emit(OtpError(f.messageKey));
    }
  }

  Future<void> verifyPhoneOtp(String phone, String token) async {
    emit(const OtpVerifying());
    final result = await _verifyOtp.phone(
      OtpVerifyParams(target: phone, token: token, type: OtpType.sms),
    );
    switch (result) {
      case Success():
        emit(const OtpVerified());
      case Failure(failure: final f):
        emit(OtpError(f.messageKey));
    }
  }

  void resetResendCount() {
    _resendCount = 0;
  }
}
