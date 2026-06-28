import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/reset_password.dart';
import 'forgot_password_state.dart';

final class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._resetPassword) : super(const ForgotPasswordInitial());

  final ResetPassword _resetPassword;

  Future<void> sendResetEmail(String email) async {
    emit(const ForgotPasswordSending());
    final result = await _resetPassword(EmailParams(email: email));
    switch (result) {
      case Success():
        emit(const ForgotPasswordSent());
      case Failure(failure: final f):
        emit(ForgotPasswordError(f.messageKey));
    }
  }
}
