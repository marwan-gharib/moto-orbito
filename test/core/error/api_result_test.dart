import 'package:flutter_test/flutter_test.dart';
import 'package:moto_orbito/core/error/api_result.dart';
import 'package:moto_orbito/core/error/failure.dart';

void main() {
  group('ApiResult', () {
    test('Success holds correct data', () {
      const result = Success('test_data');
      expect(result.data, 'test_data');
    });

    test('Failure holds correct AppFailure', () {
      const failure = UnexpectedFailure();
      const result = Failure(failure);
      expect(result.failure, failure);
    });

    test('Exhaustive switch works correctly', () {
      const ApiResult<int> result = Success(42);
      final value = switch (result) {
        Success(data: final data) => data,
        Failure() => 0,
      };
      expect(value, 42);
    });
  });
}
