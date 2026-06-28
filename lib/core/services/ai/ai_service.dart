import 'dart:async';

import '../../error/api_result.dart';
import '../../error/failure.dart';
import '../../network/base_api_client.dart';

abstract interface class AiService {
  Future<ApiResult<Map<String, dynamic>>> invoke({
    required String promptKey,
    required Map<String, dynamic> input,
    required String languageCode,
  });
}

final class AiServiceImpl implements AiService {
  AiServiceImpl(this._apiClient);

  static const int _maxRetries = 2;
  static const Duration _timeout = Duration(seconds: 30);

  final BaseApiClient _apiClient;

  @override
  Future<ApiResult<Map<String, dynamic>>> invoke({
    required String promptKey,
    required Map<String, dynamic> input,
    required String languageCode,
  }) async {
    var attempt = 0;
    while (attempt <= _maxRetries) {
      try {
        final result = await _apiClient
            .post<Map<String, dynamic>>(
              '/functions/v1/ai-proxy',
              body: {
                'prompt_key': promptKey,
                'input': input,
                'language_code': languageCode,
              },
              fromJson: (json) => Map<String, dynamic>.from(json as Map),
            )
            .timeout(_timeout);

        switch (result) {
          case Success<Map<String, dynamic>>():
            return result;
          case Failure<Map<String, dynamic>>():
            if (attempt == _maxRetries) return result;
        }
      } on TimeoutException {
        return const Failure(NetworkFailure());
      }

      attempt++;
      await Future<void>.delayed(Duration(milliseconds: 250 * attempt));
    }

    return const Failure(ServerFailure());
  }
}
