import '../../view_models/user_view_model.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {
  const LoginInitial();
}

final class LoginLoading extends LoginState {
  const LoginLoading();
}

final class LoginSuccess extends LoginState {
  const LoginSuccess(this.user);

  final UserViewModel user;
}

final class LoginError extends LoginState {
  const LoginError(this.message);

  final String message;
}
