import 'package:moto_orbito/core/i18n/strings.g.dart';

import '../failure.dart';
import '../failure_type.dart';
import 'failure_message_strategy.dart';

final class AuthFailureStrategy implements FailureMessageStrategy {
  const AuthFailureStrategy();

  @override
  String getMessage(AppFailure failure) {
    return switch (failure.type) {
      FailureType.emailAlreadyExists => t.auth.emailAlreadyExists,
      FailureType.emailNotVerified => t.auth.emailNotVerified,
      FailureType.emailUnverifiedExists => t.auth.emailUnverifiedExists,
      FailureType.invalidCredentials => t.auth.invalidCredentials,
      FailureType.otpExpired => t.auth.otpExpired,
      FailureType.invalidOtp => t.auth.invalidOtp,
      FailureType.auth => t.errors.auth,
      _ => t.errors.auth,
    };
  }
}
