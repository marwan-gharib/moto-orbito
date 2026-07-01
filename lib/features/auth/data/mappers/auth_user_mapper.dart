import '../../domain/entities/user_entity.dart';
import '../models/auth_user_model.dart';

final class AuthUserMapper {
  const AuthUserMapper._();

  static UserEntity toEntity(AuthUserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      fullName: model.fullName,
      phone: model.phone,
      isEmailVerified: model.emailConfirmedAt != null,
      isPhoneVerified: model.phoneVerifiedAt != null,
      fcmToken: model.fcmToken,
      locale: model.locale,
      createdAt: DateTime.parse(model.createdAt),
      profilePicture: model.profilePicture,
    );
  }

  static AuthUserModel toModel(UserEntity entity) {
    return AuthUserModel(
      id: entity.id,
      email: entity.email,
      emailConfirmedAt: entity.isEmailVerified ? DateTime.now().toIso8601String() : null,
      fullName: entity.fullName,
      phone: entity.phone,
      phoneVerifiedAt: entity.isPhoneVerified ? DateTime.now().toIso8601String() : null,
      fcmToken: entity.fcmToken,
      locale: entity.locale,
      createdAt: entity.createdAt.toIso8601String(),
      profilePicture: entity.profilePicture,
    );
  }
}
