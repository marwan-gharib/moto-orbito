import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';

import 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  Future<void> checkSession() async {
    emit(const AuthLoading());
    final result = await _authRepository.getSession();
    switch (result) {
      case Success(data: final user?):
        emit(AuthAuthenticated(user));
      case Success(data: null):
        emit(const AuthUnauthenticated());
      case Failure(failure: final f):
        emit(AuthError(f.messageKey));
    }
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _authRepository.signOut();
    switch (result) {
      case Success():
        emit(const AuthUnauthenticated());
      case Failure(failure: final f):
        emit(AuthError(f.messageKey));
    }
  }

  Future<void> deleteAccount() async {
    emit(const AuthLoading());
    final result = await _authRepository.deleteAccount();
    switch (result) {
      case Success():
        emit(const AuthUnauthenticated());
      case Failure(failure: final f):
        emit(AuthError(f.messageKey));
    }
  }

  void setUser(UserEntity user) {
    emit(AuthAuthenticated(user));
  }
}
