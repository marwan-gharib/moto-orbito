import 'package:get_it/get_it.dart';

import '../../../core/network/base_api_client.dart';
import '../../../core/services/supabase/storage_service.dart';
import '../../../core/services/supabase/supabase_service.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/use_cases/delete_account.dart';
import '../domain/use_cases/login.dart';
import '../domain/use_cases/reset_password.dart';
import '../domain/use_cases/send_otp.dart';
import '../domain/use_cases/sign_up.dart';
import '../domain/use_cases/social_login.dart';
import '../domain/use_cases/verify_otp.dart';
import '../presentation/cubit/auth_cubit.dart';
import '../presentation/cubit/forgot_password_cubit.dart';
import '../presentation/cubit/login_cubit.dart';
import '../presentation/cubit/otp_cubit.dart';
import '../presentation/cubit/sign_up_cubit.dart';

void registerAuthModule() {
  final sl = GetIt.instance;

  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        sl<SupabaseService>(),
        sl<BaseApiClient>(),
        sl<StorageService>(),
      ),
    );
  }

  if (!sl.isRegistered<SignUp>()) {
    sl.registerLazySingleton<SignUp>(() => SignUp(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<SendOtp>()) {
    sl.registerLazySingleton<SendOtp>(() => SendOtp(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<VerifyOtp>()) {
    sl.registerLazySingleton<VerifyOtp>(() => VerifyOtp(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<Login>()) {
    sl.registerLazySingleton<Login>(() => Login(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<SocialLogin>()) {
    sl.registerLazySingleton<SocialLogin>(
        () => SocialLogin(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<ResetPassword>()) {
    sl.registerLazySingleton<ResetPassword>(
        () => ResetPassword(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<DeleteAccount>()) {
    sl.registerLazySingleton<DeleteAccount>(
        () => DeleteAccount(sl<AuthRepository>()));
  }

  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerLazySingleton<AuthCubit>(
      () => AuthCubit(sl<AuthRepository>()),
    );
  }

  if (!sl.isRegistered<SignUpCubit>()) {
    sl.registerFactory<SignUpCubit>(() => SignUpCubit(sl<SignUp>()));
  }

  if (!sl.isRegistered<LoginCubit>()) {
    sl.registerFactory<LoginCubit>(
      () => LoginCubit(sl<Login>(), sl<SocialLogin>()),
    );
  }

  if (!sl.isRegistered<OtpCubit>()) {
    sl.registerFactory<OtpCubit>(
      () => OtpCubit(sl<SendOtp>(), sl<VerifyOtp>()),
    );
  }

  if (!sl.isRegistered<ForgotPasswordCubit>()) {
    sl.registerFactory<ForgotPasswordCubit>(
      () => ForgotPasswordCubit(sl<ResetPassword>()),
    );
  }
}
