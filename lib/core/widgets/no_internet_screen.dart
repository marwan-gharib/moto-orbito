import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/spacing.dart';
import 'app_button.dart';

final class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({this.onRetry, super.key});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off_outlined,
                color: context.colorScheme.primary,
                size: Spacing.xxl,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                context.t.common.noConnectionTitle,
                textAlign: TextAlign.center,
                style: context.textTheme.headlineMedium,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                context.t.common.noConnectionMessage,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge,
              ),
              const SizedBox(height: Spacing.lg),
              AppButton(label: context.t.common.retry, onTap: onRetry ?? () {}),
            ],
          ),
        ),
      ),
    );
  }
}
