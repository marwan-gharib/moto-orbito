import 'package:moto_orbito/core/i18n/strings.g.dart';

import '../failure.dart';
import 'failure_message_strategy.dart';

final class PermissionFailureStrategy implements FailureMessageStrategy {
  const PermissionFailureStrategy();

  @override
  String getMessage(AppFailure failure) => t.errors.permission;
}
