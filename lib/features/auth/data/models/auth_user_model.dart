import 'package:moto_orbito/core/constants/supabase_keys.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';

final class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.email,
    this.emailConfirmedAt,
    required this.fullName,
    this.phone,
    this.phoneVerifiedAt,
    this.fcmToken,
    this.locale = 'ar',
    required this.createdAt,
  });

  final String id;
  final String email;
  final String? emailConfirmedAt;
  final String fullName;
  final String? phone;
  final String? phoneVerifiedAt;
  final String? fcmToken;
  final String locale;
  final String createdAt;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json[SupabaseKeys.id] as String,
      email: json[SupabaseKeys.email] as String,
      emailConfirmedAt: json[SupabaseKeys.emailConfirmedAt] as String?,
      fullName: json[SupabaseKeys.fullName] as String,
      phone: json[SupabaseKeys.phone] as String?,
      phoneVerifiedAt: json[SupabaseKeys.phoneVerifiedAt] as String?,
      fcmToken: json[SupabaseKeys.fcmToken] as String?,
      locale: json[SupabaseKeys.locale] as String? ?? 'ar',
      createdAt: json[SupabaseKeys.createdAt] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      SupabaseKeys.id: id,
      SupabaseKeys.email: email,
      SupabaseKeys.emailConfirmedAt: emailConfirmedAt,
      SupabaseKeys.fullName: fullName,
      SupabaseKeys.phone: phone,
      SupabaseKeys.phoneVerifiedAt: phoneVerifiedAt,
      SupabaseKeys.fcmToken: fcmToken,
      SupabaseKeys.locale: locale,
      SupabaseKeys.createdAt: createdAt,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      fullName: fullName,
      phone: phone,
      isEmailVerified: emailConfirmedAt != null,
      isPhoneVerified: phoneVerifiedAt != null,
      fcmToken: fcmToken,
      locale: locale,
      createdAt: DateTime.parse(createdAt),
    );
  }
}
