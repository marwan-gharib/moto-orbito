import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/use_cases/check_onboarding_complete.dart';
import '../../../domain/use_cases/mark_onboarding_complete.dart';
import 'onboarding_state.dart';

final class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(
    this._checkOnboardingComplete,
    this._markOnboardingComplete,
    this._messageResolver,
  ) : super(const OnboardingInitial());

  final CheckOnboardingComplete _checkOnboardingComplete;
  final MarkOnboardingComplete _markOnboardingComplete;
  final FailureMessageResolver _messageResolver;

  static const int totalPages = 3;

  Future<void> checkOnboardingStatus() async {
    final result = await _checkOnboardingComplete();
    result.fold(
      onFailure: (_) => emit(const OnboardingInProgress(currentPage: 0)),
      onSuccess: (data) => emit(
        data ? const OnboardingComplete() : const OnboardingInProgress(currentPage: 0),
      ),
    );
  }

  void setPage(int page) {
    emit(OnboardingInProgress(currentPage: page));
  }

  void nextPage() {
    if (state case OnboardingInProgress(currentPage: final page)) {
      if (page < totalPages - 1) {
        setPage(page + 1);
      }
    }
  }

  Future<void> completeOnboarding() async {
    final result = await _markOnboardingComplete();
    result.fold(
      onFailure: (f) => emit(OnboardingError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const OnboardingComplete()),
    );
  }
}
