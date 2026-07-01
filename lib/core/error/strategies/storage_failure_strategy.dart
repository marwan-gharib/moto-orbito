import 'package:moto_orbito/core/i18n/strings.g.dart';

import '../failure.dart';
import 'failure_message_strategy.dart';

final class StorageFailureStrategy implements FailureMessageStrategy {
  const StorageFailureStrategy();

  @override
  String getMessage(AppFailure failure) => t.errors.storage;
}
