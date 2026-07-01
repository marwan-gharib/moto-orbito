import '../../../domain/entities/user_entity.dart';

sealed class SignUpState {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {
  const SignUpInitial();
}

final class SignUpLoading extends SignUpState {
  const SignUpLoading();
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess({required this.user});

  final UserEntity user;
}

final class SignUpError extends SignUpState {
  const SignUpError(this.message);

  final String message;
}
