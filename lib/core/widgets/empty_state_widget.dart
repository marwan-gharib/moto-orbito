import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/spacing.dart';
import 'app_button.dart';

final class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    required this.title,
    required this.subtitle,
    this.ctaLabel,
    this.onCtaTap,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              color: context.colorScheme.primary,
              size: Spacing.xxl,
            ),
            const SizedBox(height: Spacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge,
            ),
            const SizedBox(height: Spacing.sm),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            if (ctaLabel != null && onCtaTap != null) ...[
              const SizedBox(height: Spacing.lg),
              AppButton(label: ctaLabel!, onTap: onCtaTap),
            ],
          ],
        ),
      ),
    );
  }
}
