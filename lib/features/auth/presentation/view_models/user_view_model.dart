final class UserViewModel {
  const UserViewModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.username,
    this.profilePicture,
    this.isEmailVerified = false,
    this.isFirstTimeUser = false,
  });

  final String id;
  final String email;
  final String fullName;
  final String username;
  final String? profilePicture;
  final bool isEmailVerified;
  final bool isFirstTimeUser;
}
