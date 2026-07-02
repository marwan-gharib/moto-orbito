import 'otp_type.dart';

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
