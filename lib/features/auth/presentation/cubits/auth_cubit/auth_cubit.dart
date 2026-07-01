import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/features/auth/domain/entities/user_entity.dart';
import 'package:moto_orbito/features/auth/domain/repositories/auth_repository.dart';

import 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._messageResolver)
      : super(const AuthInitial());

  final AuthRepository _authRepository;
  final FailureMessageResolver _messageResolver;

  Future<void> checkSession() async {
    emit(const AuthLoading());
    final result = await _authRepository.getSession();
    result.fold(
      onFailure: (f) => emit(AuthError(_messageResolver.resolve(f))),
      onSuccess: (user) => emit(
        user != null ? AuthAuthenticated(user) : const AuthUnauthenticated(),
      ),
    );
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _authRepository.signOut();
    result.fold(
      onFailure: (f) => emit(AuthError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> deleteAccount() async {
    emit(const AuthLoading());
    final result = await _authRepository.deleteAccount();
    result.fold(
      onFailure: (f) => emit(AuthError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const AuthUnauthenticated()),
    );
  }

  void setUser(UserEntity user) {
    emit(AuthAuthenticated(user));
  }
}
