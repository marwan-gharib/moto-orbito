import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login.dart';
import '../../domain/use_cases/social_login.dart';
import 'login_state.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login, this._socialLogin) : super(const LoginInitial());

  final Login _login;
  final SocialLogin _socialLogin;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());
    final params = LoginParams(email: email, password: password);
    final result = await _login(params);
    switch (result) {
      case Success(data: final user):
        emit(LoginSuccess(user));
      case Failure(failure: final f):
        emit(LoginError(f.messageKey));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const LoginLoading());
    final result = await _socialLogin.google();
    switch (result) {
      case Success(data: final user):
        emit(LoginSuccess(user));
      case Failure(failure: final f):
        emit(LoginError(f.messageKey));
    }
  }

  Future<void> signInWithFacebook() async {
    emit(const LoginLoading());
    final result = await _socialLogin.facebook();
    switch (result) {
      case Success(data: final user):
        emit(LoginSuccess(user));
      case Failure(failure: final f):
        emit(LoginError(f.messageKey));
    }
  }
}
