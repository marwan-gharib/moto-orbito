import 'package:moto_orbito/core/i18n/strings.g.dart';

import '../failure.dart';
import 'failure_message_strategy.dart';

final class NetworkFailureStrategy implements FailureMessageStrategy {
  const NetworkFailureStrategy();

  @override
  String getMessage(AppFailure failure) => t.errors.network;
}
