import 'package:moto_orbito/core/constants/supabase_keys.dart';

final class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.email,
    this.emailConfirmedAt,
    required this.fullName,
    required this.username,
    this.fcmToken,
    this.locale = 'ar',
    required this.createdAt,
    this.profilePicture,
  });

  final String id;
  final String email;
  final String? emailConfirmedAt;
  final String fullName;
  final String username;
  final String? fcmToken;
  final String locale;
  final String createdAt;
  final String? profilePicture;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json[SupabaseKeys.id] as String,
      email: json[SupabaseKeys.email] as String,
      emailConfirmedAt: json[SupabaseKeys.emailConfirmedAt] as String?,
      fullName: json[SupabaseKeys.fullName] as String,
      username: json[SupabaseKeys.username] as String,
      fcmToken: json[SupabaseKeys.fcmToken] as String?,
      locale: json[SupabaseKeys.locale] as String? ?? 'ar',
      createdAt: json[SupabaseKeys.createdAt] as String,
      profilePicture: json[SupabaseKeys.profilePicture] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SupabaseKeys.id: id,
      SupabaseKeys.email: email,
      SupabaseKeys.emailConfirmedAt: emailConfirmedAt,
      SupabaseKeys.fullName: fullName,
      SupabaseKeys.username: username,
      SupabaseKeys.fcmToken: fcmToken,
      SupabaseKeys.locale: locale,
      SupabaseKeys.createdAt: createdAt,
      SupabaseKeys.profilePicture: profilePicture,
    };
  }
}
