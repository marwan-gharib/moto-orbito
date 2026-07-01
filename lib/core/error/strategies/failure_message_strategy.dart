import '../failure.dart';

abstract class FailureMessageStrategy {
  String getMessage(AppFailure failure);
}
