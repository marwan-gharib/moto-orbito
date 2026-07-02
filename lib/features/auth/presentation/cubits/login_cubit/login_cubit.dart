import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/params/params.dart';
import '../../../domain/use_cases/login.dart';
import '../../../domain/use_cases/social_login.dart';
import '../../view_models/user_view_model.dart';
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
      onSuccess: (data) => emit(LoginSuccess(_mapToViewModel(data))),
    );
  }

  Future<void> signInWithGoogle() async {
    emit(const LoginLoading());
    final result = await _socialLogin.google();
    result.fold(
      onFailure: (failure) =>
          emit(LoginError(_messageResolver.resolve(failure))),
      onSuccess: (data) => emit(LoginSuccess(_mapToViewModel(data))),
    );
  }

  Future<void> signInWithFacebook() async {
    emit(const LoginLoading());
    final result = await _socialLogin.facebook();
    result.fold(
      onFailure: (failure) =>
          emit(LoginError(_messageResolver.resolve(failure))),
      onSuccess: (data) => emit(LoginSuccess(_mapToViewModel(data))),
    );
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
