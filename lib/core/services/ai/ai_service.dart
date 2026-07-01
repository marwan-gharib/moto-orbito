import 'dart:async';

import '../../constants/app_constants.dart';
import '../../constants/app_links.dart';
import '../../error/api_result.dart';
import '../../error/failure.dart';
import '../../network/base_api_client.dart';

final class AiService {
  AiService(this._apiClient);

  static const int _maxRetries = AppConstants.aiMaxRetries;
  static const Duration _timeout = Duration(seconds: AppConstants.aiTimeoutSeconds);

  final BaseApiClient _apiClient;

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
              AppLinks.aiProxy,
              body: {
                'prompt_key': promptKey,
                'input': input,
                'language_code': languageCode,
              },
              fromJson: (json) => Map<String, dynamic>.from(json as Map),
            )
            .timeout(_timeout);

        final shouldReturn = result.fold(
          onFailure: (_) => attempt == _maxRetries,
          onSuccess: (_) => true,
        );
        if (shouldReturn) return result;
      } on TimeoutException {
        return const Failure(NetworkFailure());
      }

      attempt++;
      await Future<void>.delayed(Duration(milliseconds: 250 * attempt));
    }

    return const Failure(ServerFailure());
  }
}

