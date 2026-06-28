sealed class OnboardingState {
  const OnboardingState();
}

final class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

final class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress({this.currentPage = 0});

  final int currentPage;
}

final class OnboardingComplete extends OnboardingState {
  const OnboardingComplete();
}

final class OnboardingError extends OnboardingState {
  const OnboardingError(this.messageKey);

  final String messageKey;
}
