sealed class OtpState {
  const OtpState();
}

final class OtpInitial extends OtpState {
  const OtpInitial();
}

final class OtpSending extends OtpState {
  const OtpSending();
}

final class OtpSent extends OtpState {
  const OtpSent({
    this.resendCountdownSeconds = 30,
    this.resendAttemptsRemaining = 2,
  });

  final int resendCountdownSeconds;
  final int resendAttemptsRemaining;
}

final class OtpVerifying extends OtpState {
  const OtpVerifying();
}

final class OtpVerified extends OtpState {
  const OtpVerified();
}

final class OtpError extends OtpState {
  const OtpError(this.messageKey);

  final String messageKey;
}

final class OtpResendExhausted extends OtpState {
  const OtpResendExhausted();
}
