import 'dart:typed_data';

final class SignUpParams {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.username,
    this.profilePicturePath,
    this.profilePictureBytes,
  });

  final String email;
  final String password;
  final String fullName;
  final String username;
  final String? profilePicturePath;
  final Uint8List? profilePictureBytes;
}
