import 'package:dio/dio.dart';
import 'package:moto_orbito/core/constants/app_failure_keys.dart';
import 'package:moto_orbito/core/constants/app_constants.dart';
import 'package:moto_orbito/core/constants/app_links.dart';
import 'package:moto_orbito/core/constants/supabase_keys.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_mapper.dart';
import 'package:moto_orbito/core/network/base_api_client.dart';
import 'package:moto_orbito/core/services/supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_user_model.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._supabaseService, this._apiClient);

  final SupabaseService _supabaseService;
  final BaseApiClient _apiClient;

  supabase.SupabaseClient get _client => _supabaseService.client;

  @override
  Future<ApiResult<UserEntity>> signUpWithEmailPassword(
    SignUpParams params,
  ) async {
    try {
      final response = await _client.auth.signUp(
        email: params.email,
        password: params.password,
        data: {
          SupabaseKeys.fullName: params.fullName,
          SupabaseKeys.phone: params.phone,
        },
      );
      final user = response.user;
      if (user == null) {
        return const Failure(AuthFailure());
      }
      final model = AuthUserModel(
        id: user.id,
        email: user.email ?? params.email,
        emailConfirmedAt: user.emailConfirmedAt,
        fullName: params.fullName,
        phone: params.phone,
        locale: AppConstants.defaultLocale,
        createdAt: user.createdAt,
      );
      return Success(model.toEntity());
    } on supabase.AuthException catch (e) {
      return Failure(
        AuthFailure(
          messageKey: e.message.contains('already registered')
              ? AppFailureKeys.emailAlreadyExists
              : AppFailureKeys.auth,
        ),
      );
    } on DioException catch (e) {
      return Failure(FailureMapper.fromDioException(e));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<UserEntity>> signInWithEmailPassword(
    LoginParams params,
  ) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: params.email,
        password: params.password,
      );
      final user = response.user;
      if (user == null) {
        return const Failure(AuthFailure());
      }
      if (user.emailConfirmedAt == null) {
        await _client.auth.signOut();
        return const Failure(AuthFailure(messageKey: AppFailureKeys.emailNotVerified));
      }
      final raw = await _client
          .from(SupabaseKeys.users)
          .select()
          .eq(SupabaseKeys.id, user.id)
          .single();
      final json = Map<String, dynamic>.from(raw as Map);
      json[SupabaseKeys.emailConfirmedAt] = user.emailConfirmedAt;
      final model = AuthUserModel.fromJson(json);
      return Success(model.toEntity());
    } on supabase.AuthException catch (e) {
      return Failure(
        AuthFailure(
          messageKey: e.message.contains('Invalid login credentials')
              ? AppFailureKeys.invalidCredentials
              : AppFailureKeys.auth,
        ),
      );
    } on DioException catch (e) {
      return Failure(FailureMapper.fromDioException(e));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<UserEntity>> signInWithGoogle() async {
    try {
      await _client.auth.signInWithOAuth(
        supabase.OAuthProvider.google,
        redirectTo: AppLinks.oauthRedirectUri,
      );
      final session = _client.auth.currentSession;
      final sessionUser = session?.user;
      if (sessionUser == null) {
        return const Failure(AuthFailure());
      }
      final isFirst = await isFirstTimeUser(sessionUser.id);
      final model = AuthUserModel(
        id: sessionUser.id,
        email: sessionUser.email ?? '',
        emailConfirmedAt: sessionUser.emailConfirmedAt,
        fullName: sessionUser.userMetadata?[SupabaseKeys.fullName] as String? ?? '',
        locale: AppConstants.defaultLocale,
        createdAt: sessionUser.createdAt,
      );
      return Success(model.toEntity().copyWith(isFirstTimeUser: isFirst));
    } on supabase.AuthException catch (e) {
      return Failure(AuthFailure(messageKey: e.message));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<UserEntity>> signInWithFacebook() async {
    try {
      await _client.auth.signInWithOAuth(
        supabase.OAuthProvider.facebook,
        redirectTo: AppLinks.oauthRedirectUri,
      );
      final session = _client.auth.currentSession;
      final sessionUser = session?.user;
      if (sessionUser == null) {
        return const Failure(AuthFailure());
      }
      final isFirst = await isFirstTimeUser(sessionUser.id);
      final model = AuthUserModel(
        id: sessionUser.id,
        email: sessionUser.email ?? '',
        emailConfirmedAt: sessionUser.emailConfirmedAt,
        fullName: sessionUser.userMetadata?[SupabaseKeys.name] as String? ?? '',
        locale: AppConstants.defaultLocale,
        createdAt: sessionUser.createdAt,
      );
      return Success(model.toEntity().copyWith(isFirstTimeUser: isFirst));
    } on supabase.AuthException catch (e) {
      return Failure(AuthFailure(messageKey: e.message));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<void>> sendEmailOtp(EmailParams params) async {
    try {
      await _client.auth.signInWithOtp(email: params.email);
      return const Success(null);
    } on supabase.AuthException catch (e) {
      return Failure(AuthFailure(messageKey: e.message));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<void>> verifyEmailOtp(OtpVerifyParams params) async {
    try {
      await _client.auth.verifyOTP(
        type: supabase.OtpType.email,
        token: params.token,
        email: params.target,
      );
      return const Success(null);
    } on supabase.AuthException catch (e) {
      return Failure(
        AuthFailure(
          messageKey: e.message.contains('expired')
              ? AppFailureKeys.otpExpired
              : AppFailureKeys.invalidOtp,
        ),
      );
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<void>> sendPhoneOtp(PhoneParams params) async {
    try {
      await _client.auth.signInWithOtp(phone: params.phone);
      return const Success(null);
    } on supabase.AuthException catch (e) {
      return Failure(AuthFailure(messageKey: e.message));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<void>> verifyPhoneOtp(OtpVerifyParams params) async {
    try {
      await _client.auth.verifyOTP(
        type: supabase.OtpType.sms,
        token: params.token,
        phone: params.target,
      );
      return const Success(null);
    } on supabase.AuthException catch (e) {
      return Failure(
        AuthFailure(
          messageKey: e.message.contains('expired')
              ? AppFailureKeys.otpExpired
              : AppFailureKeys.invalidOtp,
        ),
      );
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<void>> sendPasswordResetEmail(EmailParams params) async {
    try {
      await _client.auth.resetPasswordForEmail(params.email);
      return const Success(null);
    } on Object {
      return const Success(null);
    }
  }

  @override
  Future<ApiResult<void>> signOut() async {
    try {
      final session = _client.auth.currentSession;
      final sessionUser = session?.user;
      if (sessionUser != null) {
        await _client
            .from(SupabaseKeys.users)
            .update({SupabaseKeys.fcmToken: null})
            .eq(SupabaseKeys.id, sessionUser.id);
      }
      await _client.auth.signOut();
      return const Success(null);
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<void>> deleteAccount() async {
    try {
      await _apiClient.delete(AppLinks.deleteAccount);
      await _client.auth.signOut();
      return const Success(null);
    } on DioException catch (e) {
      return Failure(FailureMapper.fromDioException(e));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<UserEntity?>> getSession() async {
    try {
      final session = _client.auth.currentSession;
      final sessionUser = session?.user;
      if (sessionUser == null) {
        return const Success(null);
      }
      final raw = await _client
          .from(SupabaseKeys.users)
          .select()
          .eq(SupabaseKeys.id, sessionUser.id)
          .single();
      final json = Map<String, dynamic>.from(raw as Map);
      json[SupabaseKeys.emailConfirmedAt] = sessionUser.emailConfirmedAt;
      final model = AuthUserModel.fromJson(json);
      return Success(model.toEntity());
    } on supabase.AuthException {
      return const Success(null);
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<bool> isFirstTimeUser(String uid) async {
    try {
      final result = await _client
          .from(SupabaseKeys.users)
          .select(SupabaseKeys.id)
          .eq(SupabaseKeys.id, uid)
          .limit(1);
      return (result as List).isEmpty;
    } on Object {
      return true;
    }
  }
}
