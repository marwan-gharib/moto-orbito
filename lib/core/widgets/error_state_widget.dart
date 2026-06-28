import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/spacing.dart';
import 'app_button.dart';

final class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    required this.messageKey,
    required this.onRetry,
    super.key,
  });

  final String messageKey;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: context.colors.error,
              size: Spacing.xxl,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              context.t[messageKey],
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge,
            ),
            const SizedBox(height: Spacing.lg),
            AppButton(label: context.t.common.retry, onTap: onRetry),
          ],
        ),
      ),
    );
  }
}
