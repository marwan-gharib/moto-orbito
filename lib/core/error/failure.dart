sealed class AppFailure {
  const AppFailure(this.messageKey);

  final String messageKey;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure() : super('errors.network');
}

final class ServerFailure extends AppFailure {
  const ServerFailure({this.statusCode}) : super('errors.server');

  final int? statusCode;
}

final class AuthFailure extends AppFailure {
  const AuthFailure({String? messageKey}) : super(messageKey ?? 'errors.auth');
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure() : super('errors.notFound');
}

final class PermissionFailure extends AppFailure {
  const PermissionFailure() : super('errors.permission');
}

final class StorageFailure extends AppFailure {
  const StorageFailure() : super('errors.storage');
}

final class UnexpectedFailure extends AppFailure {
  const UnexpectedFailure() : super('errors.unexpected');
}
