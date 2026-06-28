import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/login.dart';
import 'login_state.dart';

final class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._login) : super(const LoginInitial());

  final Login _login;

  Stream<LoginState> login({
    required String email,
    required String password,
  }) async* {
    yield const LoginLoading();
    final params = LoginParams(email: email, password: password);
    final result = await _login(params);
    switch (result) {
      case Success(data: final user):
        yield LoginSuccess(user);
      case Failure(failure: final f):
        yield LoginError(f.messageKey);
    }
  }
}
