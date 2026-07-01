sealed class ForgotPasswordState {
  const ForgotPasswordState();
}

final class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

final class ForgotPasswordSending extends ForgotPasswordState {
  const ForgotPasswordSending();
}

final class ForgotPasswordSent extends ForgotPasswordState {
  const ForgotPasswordSent();
}

final class ForgotPasswordError extends ForgotPasswordState {
  const ForgotPasswordError(this.message);

  final String message;
}
