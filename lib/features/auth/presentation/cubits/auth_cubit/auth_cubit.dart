import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/use_cases/delete_account.dart';
import '../../../domain/use_cases/get_session.dart';
import '../../../domain/use_cases/sign_out.dart';
import '../../view_models/user_view_model.dart';
import 'auth_state.dart';

final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._getSession,
    this._signOut,
    this._deleteAccount,
    this._messageResolver,
  ) : super(const AuthInitial());

  final GetSession _getSession;
  final SignOutUseCase _signOut;
  final DeleteAccount _deleteAccount;
  final FailureMessageResolver _messageResolver;

  Future<void> checkSession() async {
    emit(const AuthLoading());
    final result = await _getSession();
    result.fold(
      onFailure: (f) => emit(AuthError(_messageResolver.resolve(f))),
      onSuccess: (user) => emit(
        user != null
            ? AuthAuthenticated(_mapToViewModel(user))
            : const AuthUnauthenticated(),
      ),
    );
  }

  Future<void> signOut() async {
    emit(const AuthLoading());
    final result = await _signOut();
    result.fold(
      onFailure: (f) => emit(AuthError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> deleteAccount() async {
    emit(const AuthLoading());
    final result = await _deleteAccount();
    result.fold(
      onFailure: (f) => emit(AuthError(_messageResolver.resolve(f))),
      onSuccess: (_) => emit(const AuthUnauthenticated()),
    );
  }

  void setUser(UserViewModel user) {
    emit(AuthAuthenticated(user));
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
