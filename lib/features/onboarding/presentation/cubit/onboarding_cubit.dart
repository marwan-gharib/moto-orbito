import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/use_cases/check_onboarding_complete.dart';
import '../../domain/use_cases/mark_onboarding_complete.dart';
import 'onboarding_state.dart';

final class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._checkOnboardingComplete, this._markOnboardingComplete)
    : super(const OnboardingInitial());

  final CheckOnboardingComplete _checkOnboardingComplete;
  final MarkOnboardingComplete _markOnboardingComplete;

  static const int totalPages = 3;

  Future<void> checkOnboardingStatus() async {
    final result = await _checkOnboardingComplete();
    switch (result) {
      case Success(data: true):
        emit(const OnboardingComplete());
      case Success(data: false):
        emit(const OnboardingInProgress(currentPage: 0));
      case Failure():
        emit(const OnboardingInProgress(currentPage: 0));
    }
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
    switch (result) {
      case Success():
        emit(const OnboardingComplete());
      case Failure(failure: final f):
        emit(OnboardingError(f.messageKey));
    }
  }
}
