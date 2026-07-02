import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/repositories/params/params.dart';
import '../../../domain/use_cases/reset_password.dart';
import 'forgot_password_state.dart';

final class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this._resetPassword, this._messageResolver)
      : super(const ForgotPasswordInitial());

  final ResetPassword _resetPassword;
  final FailureMessageResolver _messageResolver;

  Future<void> sendResetEmail(String email) async {
    emit(const ForgotPasswordSending());
    final result = await _resetPassword(EmailParams(email: email));
    result.fold(
      onFailure: (f) => emit(ForgotPasswordError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const ForgotPasswordSent()),
    );
  }
}
