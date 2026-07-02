import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/params/params.dart';
import '../../../domain/use_cases/check_username_availability.dart';
import '../../../domain/use_cases/sign_up.dart';
import '../../view_models/user_view_model.dart';
import 'sign_up_state.dart';

final class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(
    this._signUp,
    this._checkUsername,
    this._messageResolver,
  ) : super(const SignUpInitial());

  final SignUp _signUp;
  final CheckUsernameAvailability _checkUsername;
  final FailureMessageResolver _messageResolver;

  Uint8List? profileImageBytes;
  String? profileImageName;

  void setProfileImage(Uint8List bytes, String name) {
    profileImageBytes = bytes;
    profileImageName = name;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String username,
  }) async {
    emit(const SignUpLoading());

    final usernameResult = await _checkUsername(UsernameCheckParams(username));
    final isAvailable = usernameResult.fold(
      onFailure: (_) => false,
      onSuccess: (available) => available,
    );

    if (!isAvailable) {
      emit(const SignUpUsernameTaken());
      return;
    }

    final params = SignUpParams(
      email: email,
      password: password,
      fullName: fullName,
      username: username,
      profilePicturePath: profileImageName,
      profilePictureBytes: profileImageBytes,
    );
    final result = await _signUp(params);
    result.fold(
      onFailure: (f) {
        if (f is EmailUnverifiedExists) {
          emit(const SignUpEmailUnverified());
        } else {
          emit(SignUpError(_messageResolver.resolve(f)));
        }
      },
      onSuccess: (user) => emit(SignUpSuccess(user: _mapToViewModel(user))),
    );
  }

  void resetState() {
    profileImageBytes = null;
    profileImageName = null;
    emit(const SignUpInitial());
  }

  UserViewModel _mapToViewModel(UserEntity entity) {
    return UserViewModel(
      id: entity.id,
      email: entity.email,
      fullName: entity.fullName,
      username: entity.username,
      profilePicture: entity.profilePicture,
      isEmailVerified: entity.isEmailVerified,
      isFirstTimeUser: entity.isFirstTimeUser,
    );
  }
}
