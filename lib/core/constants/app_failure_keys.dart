/// Failure message-key constants used across all features.
/// These map to keys in the `errors` and `auth` namespaces in `assets/i18n/*.json`.
final class AppFailureKeys {
  const AppFailureKeys._();

  static const String network = 'errors.network';
  static const String server = 'errors.server';
  static const String auth = 'errors.auth';
  static const String notFound = 'errors.notFound';
  static const String permission = 'errors.permission';
  static const String storage = 'errors.storage';
  static const String unexpected = 'errors.unexpected';

  static const String emailAlreadyExists = 'auth.emailAlreadyExists';
  static const String emailNotVerified = 'auth.emailNotVerified';
  static const String invalidCredentials = 'auth.invalidCredentials';
  static const String otpExpired = 'auth.otpExpired';
  static const String invalidOtp = 'auth.invalidOtp';
}
