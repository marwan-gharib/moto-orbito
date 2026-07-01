import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/login.dart';
import '../../../domain/use_cases/social_login.dart';
import 'login_state.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login, this._socialLogin, this._messageResolver)
    : super(const LoginInitial());

  final Login _login;
  final SocialLogin _socialLogin;
  final FailureMessageResolver _messageResolver;

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());
    final params = LoginParams(email: email, password: password);
    final result = await _login(params);
    result.fold(
      onFailure: (failure) =>
          emit(LoginError(_messageResolver.resolve(failure))),
      onSuccess: (data) => emit(LoginSuccess(data)),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const LoginLoading());
    final result = await _socialLogin.google();

    result.fold(
      onFailure: (failure) =>
          emit(LoginError(_messageResolver.resolve(failure))),
      onSuccess: (data) => emit(LoginSuccess(data)),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(const LoginLoading());
    final result = await _socialLogin.facebook();
    result.fold(
      onFailure: (failure) =>
          emit(LoginError(_messageResolver.resolve(failure))),
      onSuccess: (data) => emit(LoginSuccess(data)),
    );
  }
}
