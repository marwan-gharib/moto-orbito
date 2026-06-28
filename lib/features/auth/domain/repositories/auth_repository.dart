import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/entities/user_entity.dart';

final class SignUpParams {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
  });

  final String email;
  final String password;
  final String fullName;
  final String phone;
}

final class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

final class EmailParams {
  const EmailParams({required this.email});

  final String email;
}

final class PhoneParams {
  const PhoneParams({required this.phone});

  final String phone;
}

final class OtpVerifyParams {
  const OtpVerifyParams({
    required this.target,
    required this.token,
    required this.type,
  });

  final String target;
  final String token;
  final OtpType type;
}

enum OtpType { email, sms }

abstract interface class AuthRepository {
  Future<ApiResult<UserEntity>> signUpWithEmailPassword(SignUpParams params);
  Future<ApiResult<UserEntity>> signInWithEmailPassword(LoginParams params);
  Future<ApiResult<UserEntity>> signInWithGoogle();
  Future<ApiResult<UserEntity>> signInWithFacebook();
  Future<ApiResult<void>> sendEmailOtp(EmailParams params);
  Future<ApiResult<void>> verifyEmailOtp(OtpVerifyParams params);
  Future<ApiResult<void>> sendPhoneOtp(PhoneParams params);
  Future<ApiResult<void>> verifyPhoneOtp(OtpVerifyParams params);
  Future<ApiResult<void>> sendPasswordResetEmail(EmailParams params);
  Future<ApiResult<void>> signOut();
  Future<ApiResult<void>> deleteAccount();
  Future<ApiResult<UserEntity?>> getSession();
  Future<bool> isFirstTimeUser(String uid);
}
