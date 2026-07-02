import 'failure_type.dart';

sealed class AppFailure {
  const AppFailure(this.type);

  final FailureType type;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure() : super(FailureType.network);
}

final class ServerFailure extends AppFailure {
  const ServerFailure({this.statusCode}) : super(FailureType.server);

  final int? statusCode;
}

final class AuthFailure extends AppFailure {
  const AuthFailure() : super(FailureType.auth);
}

final class EmailAlreadyExists extends AppFailure {
  const EmailAlreadyExists() : super(FailureType.emailAlreadyExists);
}

final class EmailNotVerified extends AppFailure {
  const EmailNotVerified() : super(FailureType.emailNotVerified);
}

final class EmailUnverifiedExists extends AppFailure {
  const EmailUnverifiedExists() : super(FailureType.emailUnverifiedExists);
}

final class InvalidCredentials extends AppFailure {
  const InvalidCredentials() : super(FailureType.invalidCredentials);
}

final class OtpExpired extends AppFailure {
  const OtpExpired() : super(FailureType.otpExpired);
}

final class InvalidOtp extends AppFailure {
  const InvalidOtp() : super(FailureType.invalidOtp);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure() : super(FailureType.notFound);
}

final class PermissionFailure extends AppFailure {
  const PermissionFailure() : super(FailureType.permission);
}

final class StorageFailure extends AppFailure {
  const StorageFailure() : super(FailureType.storage);
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure() : super(FailureType.unexpected);
}
