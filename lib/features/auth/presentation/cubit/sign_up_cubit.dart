import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/use_cases/sign_up.dart';
import 'sign_up_state.dart';

final class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUp) : super(const SignUpInitial());

  final SignUp _signUp;

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? profilePicturePath,
    Uint8List? profilePictureBytes,
  }) async {
    emit(const SignUpLoading());
    final params = SignUpParams(
      email: email,
      password: password,
      fullName: fullName,
      profilePicturePath: profilePicturePath,
      profilePictureBytes: profilePictureBytes,
    );
    final result = await _signUp(params);
    switch (result) {
      case Success(data: final user):
        emit(SignUpSuccess(user: user));
      case Failure(failure: final f):
        emit(SignUpError(f.messageKey));
    }
  }
}
