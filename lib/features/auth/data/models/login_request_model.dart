import 'package:moto_orbito/core/constants/supabase_keys.dart';

final class LoginRequestModel {
  const LoginRequestModel({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toJson() {
    return {SupabaseKeys.email: email, SupabaseKeys.password: password};
  }
}
