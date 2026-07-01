import 'package:moto_orbito/core/error/failure.dart';
import 'package:moto_orbito/core/error/failure_message_resolver.dart';
import 'package:moto_orbito/core/di/injection_container.dart';

extension AppFailureX on AppFailure {
  String getMessage() => sl<FailureMessageResolver>().resolve(this);
}
