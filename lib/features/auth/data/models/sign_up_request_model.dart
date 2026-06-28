import 'package:moto_orbito/core/constants/supabase_keys.dart';

final class SignUpRequestModel {
  const SignUpRequestModel({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phone,
  });

  final String email;
  final String password;
  final String fullName;
  final String phone;

  Map<String, dynamic> toJson() {
    return {
      SupabaseKeys.email: email,
      SupabaseKeys.password: password,
      SupabaseKeys.fullName: fullName,
      SupabaseKeys.phone: phone,
    };
  }
}
