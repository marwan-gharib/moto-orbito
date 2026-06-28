import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/sign_up.dart';
import 'sign_up_state.dart';

final class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUp) : super(const SignUpInitial());

  final SignUp _signUp;

  Stream<SignUpState> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async* {
    yield const SignUpLoading();
    final params = SignUpParams(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );
    final result = await _signUp(params);
    switch (result) {
      case Success():
        yield const SignUpSuccess();
      case Failure(failure: final f):
        yield SignUpError(f.messageKey);
    }
  }
}
