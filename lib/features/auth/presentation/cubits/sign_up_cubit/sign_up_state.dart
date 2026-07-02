import '../../view_models/user_view_model.dart';

sealed class SignUpState {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

final class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

final class SignUpUsernameTaken extends SignUpState {
  const SignUpUsernameTaken();
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess({required this.user});

  final UserViewModel user;
}

final class SignUpEmailUnverified extends SignUpState {
  const SignUpEmailUnverified();
}

final class SignUpError extends SignUpState {
  const SignUpError(this.message);

  final String message;
}
