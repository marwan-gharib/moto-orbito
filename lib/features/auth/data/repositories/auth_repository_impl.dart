import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:moto_orbito/core/constants/app_constants.dart';
import 'package:moto_orbito/core/constants/app_links.dart';
import 'package:moto_orbito/core/constants/supabase_keys.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_mapper.dart';
import 'package:moto_orbito/core/network/base_api_client.dart';
import 'package:moto_orbito/core/services/supabase/storage_service.dart';
import 'package:moto_orbito/core/services/supabase/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/params/params.dart';
import '../mappers/auth_user_mapper.dart';
import '../models/auth_user_model.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._supabaseService,
    this._apiClient,
    this._storageService,
  );

  final SupabaseService _supabaseService;
  final BaseApiClient _apiClient;
  final StorageService _storageService;

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
          SupabaseKeys.username: params.username,
        },
      );
      final user = response.user;
      if (user == null) {
        return const Failure(AuthFailure());
      }

      final profilePictureUrl = await _uploadProfilePicture(
        userId: user.id,
        bytes: params.profilePictureBytes,
        path: params.profilePicturePath,
      );

      final model = AuthUserModel(
        id: user.id,
        email: user.email ?? params.email,
        emailConfirmedAt: user.emailConfirmedAt,
        fullName: params.fullName,
        username: params.username,
        locale: AppConstants.defaultLocale,
        createdAt: user.createdAt,
        profilePicture: profilePictureUrl,
      );

      if (profilePictureUrl != null) {
        await _client
            .from(SupabaseKeys.users)
            .update({SupabaseKeys.profilePicture: profilePictureUrl})
            .eq(SupabaseKeys.id, user.id);
      }

      return Success(AuthUserMapper.toEntity(model));
    } on supabase.AuthException catch (e) {
      if (e.message.contains('already registered')) {
        return _handleExistingEmail(params);
      }
      return const Failure(AuthFailure());
    } on DioException catch (e) {
      return Failure(FailureMapper.fromDioException(e));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  Future<ApiResult<UserEntity>> _handleExistingEmail(SignUpParams params) async {
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
        return const Failure(EmailUnverifiedExists());
      }
      return const Failure(EmailAlreadyExists());
    } on supabase.AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return const Failure(EmailAlreadyExists());
      }
      return const Failure(EmailAlreadyExists());
    } on Object {
      return const Failure(EmailAlreadyExists());
    }
  }

  Future<String?> _uploadProfilePicture({
    required String userId,
    Uint8List? bytes,
    String? path,
  }) async {
    final imageBytes = bytes ?? await _generateDefaultAvatarBytes();
    final imagePath = path ?? 'avatar.png';

    final uploadResult = await _storageService.uploadFile(
      bucket: SupabaseKeys.profilesBucket,
      path: '$userId/$imagePath',
      bytes: imageBytes,
    );

    String? url;
    uploadResult.fold(
      onFailure: (_) => null,
      onSuccess: (resultUrl) => url = resultUrl,
    );
    return url;
  }

  Future<Uint8List> _generateDefaultAvatarBytes() async {
    const size = 200.0;
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(0, 0, size, size),
    );

    final bgPaint = ui.Paint()..color = const ui.Color(0xFFFF6B00);
    canvas.drawCircle(const ui.Offset(size / 2, size / 2), size / 2, bgPaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
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
        return const Failure(EmailNotVerified());
      }
      final raw = await _client
          .from(SupabaseKeys.users)
          .select()
          .eq(SupabaseKeys.id, user.id)
          .single();
      final json = Map<String, dynamic>.from(raw as Map);
      json[SupabaseKeys.emailConfirmedAt] = user.emailConfirmedAt;
      final model = AuthUserModel.fromJson(json);
      return Success(AuthUserMapper.toEntity(model));
    } on supabase.AuthException catch (e) {
      return Failure(
        e.message.contains('Invalid login credentials')
            ? const InvalidCredentials()
            : const AuthFailure(),
      );
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
      final fullName =
          sessionUser.userMetadata?[SupabaseKeys.fullName] as String? ??
          sessionUser.userMetadata?[SupabaseKeys.name] as String? ??
          '';
      final profilePic =
          sessionUser.userMetadata?[SupabaseKeys.avatarUrl] as String? ??
          sessionUser.userMetadata?[SupabaseKeys.picture] as String?;
      final model = AuthUserModel(
        id: sessionUser.id,
        email: sessionUser.email ?? '',
        emailConfirmedAt: sessionUser.emailConfirmedAt,
        fullName: fullName,
        username: '',
        locale: AppConstants.defaultLocale,
        createdAt: sessionUser.createdAt,
        profilePicture: profilePic,
      );
      return Success(
        AuthUserMapper.toEntity(model).copyWith(isFirstTimeUser: isFirst),
      );
    } on supabase.AuthException catch (e) {
      return Failure(FailureMapper.fromObject(e));
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
      final fullName =
          sessionUser.userMetadata?[SupabaseKeys.fullName] as String? ??
          sessionUser.userMetadata?[SupabaseKeys.name] as String? ??
          '';
      final profilePic =
          sessionUser.userMetadata?[SupabaseKeys.avatarUrl] as String? ??
          sessionUser.userMetadata?[SupabaseKeys.picture] as String?;
      final model = AuthUserModel(
        id: sessionUser.id,
        email: sessionUser.email ?? '',
        emailConfirmedAt: sessionUser.emailConfirmedAt,
        fullName: fullName,
        username: '',
        locale: AppConstants.defaultLocale,
        createdAt: sessionUser.createdAt,
        profilePicture: profilePic,
      );
      return Success(
        AuthUserMapper.toEntity(model).copyWith(isFirstTimeUser: isFirst),
      );
    } on supabase.AuthException catch (e) {
      return Failure(FailureMapper.fromObject(e));
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<void>> sendEmailOtp(EmailParams params) async {
    try {
      await _client.auth.signInWithOtp(email: params.email);
      return const Success(null);
    } on supabase.AuthException {
      return const Failure(AuthFailure());
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
        e.message.contains('expired') ? const OtpExpired() : const InvalidOtp(),
      );
    } on Object catch (e) {
      return Failure(FailureMapper.fromObject(e));
    }
  }

  @override
  Future<ApiResult<bool>> checkUsernameAvailability(
    UsernameCheckParams params,
  ) async {
    try {
      final result = await _client
          .from(SupabaseKeys.users)
          .select(SupabaseKeys.id)
          .eq(SupabaseKeys.username, params.username)
          .limit(1);
      final exists = (result as List).isNotEmpty;
      return Success(!exists);
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
      return Success(AuthUserMapper.toEntity(model));
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
