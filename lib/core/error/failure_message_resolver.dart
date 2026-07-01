import 'failure.dart';
import 'failure_type.dart';
import 'strategies/failure_message_strategy.dart';

class FailureMessageResolver {
  const FailureMessageResolver(this._strategies);

  final Map<FailureType, FailureMessageStrategy> _strategies;

  String resolve(AppFailure failure) {
    final strategy = _strategies[failure.type];
    if (strategy == null) {
      throw ArgumentError('No strategy registered for ${failure.type}');
    }
    return strategy.getMessage(failure);
  }
}
