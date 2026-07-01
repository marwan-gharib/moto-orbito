import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/sign_up.dart';
import 'sign_up_state.dart';

final class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._signUp, this._messageResolver) : super(const SignUpInitial());

  final SignUp _signUp;
  final FailureMessageResolver _messageResolver;

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
    result.fold(
      onFailure: (f) => emit(SignUpError(_messageResolver.resolve(f))),
      onSuccess: (user) => emit(SignUpSuccess(user: user)),
    );
  }
}
