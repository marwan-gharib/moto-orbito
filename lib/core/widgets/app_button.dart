import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/spacing.dart';

enum AppButtonVariant { primary, secondary }

final class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = AppButtonVariant.primary,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isPrimary = variant == AppButtonVariant.primary;
    final background = isPrimary ? colors.primary : colors.surface;
    final foreground = isPrimary ? colors.onPrimary : colors.primary;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: colors.divider,
          disabledForegroundColor: colors.onSurface,
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.md,
          ),
        ),
        onPressed: isDisabled || isLoading ? null : onTap,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isLoading
              ? SizedBox.square(
                  key: const ValueKey('loader'),
                  dimension: Spacing.lg,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: foreground,
                  ),
                )
              : Text(
                  label,
                  key: const ValueKey('label'),
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: foreground,
                  ),
                ),
        ),
      ),
    );
  }
}
