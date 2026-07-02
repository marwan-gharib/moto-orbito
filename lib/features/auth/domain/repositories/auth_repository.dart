import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/entities/user_entity.dart';
import 'params/email_params.dart';
import 'params/login_params.dart';
import 'params/otp_verify_params.dart';
import 'params/sign_up_params.dart';
import 'params/username_check_params.dart';

abstract interface class AuthRepository {
  Future<ApiResult<UserEntity>> signUpWithEmailPassword(SignUpParams params);
  Future<ApiResult<UserEntity>> signInWithEmailPassword(LoginParams params);
  Future<ApiResult<UserEntity>> signInWithGoogle();
  Future<ApiResult<UserEntity>> signInWithFacebook();
  Future<ApiResult<void>> sendEmailOtp(EmailParams params);
  Future<ApiResult<void>> verifyEmailOtp(OtpVerifyParams params);
  Future<ApiResult<bool>> checkUsernameAvailability(UsernameCheckParams params);
  Future<ApiResult<void>> sendPasswordResetEmail(EmailParams params);
  Future<ApiResult<void>> signOut();
  Future<ApiResult<void>> deleteAccount();
  Future<ApiResult<UserEntity?>> getSession();
  Future<bool> isFirstTimeUser(String uid);
}
