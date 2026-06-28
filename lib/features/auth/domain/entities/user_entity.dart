import 'package:equatable/equatable.dart';

final class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    this.phone,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.fcmToken,
    this.locale = 'ar',
    required this.createdAt,
    this.isFirstTimeUser = false,
  });

  final String id;
  final String email;
  final String fullName;
  final String? phone;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? fcmToken;
  final String locale;
  final DateTime createdAt;
  final bool isFirstTimeUser;

  UserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? fcmToken,
    String? locale,
    DateTime? createdAt,
    bool? isFirstTimeUser,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      fcmToken: fcmToken ?? this.fcmToken,
      locale: locale ?? this.locale,
      createdAt: createdAt ?? this.createdAt,
      isFirstTimeUser: isFirstTimeUser ?? this.isFirstTimeUser,
    );
  }

  @override
  List<Object?> get props => [id];
}
