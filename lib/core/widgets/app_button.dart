import 'package:flutter/material.dart';
import 'package:moto_orbito/core/utils/enums.dart';

import '../extensions/context_extensions.dart';
import '../theme/spacing.dart';

final class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    this.variant = AppButtonVariant.primary,
    this.leading,
    this.borderColor,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isDisabled;
  final AppButtonVariant variant;
  final Widget? leading;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isPrimary = variant == AppButtonVariant.primary;
    final background = isPrimary ? colors.primary : colors.surface;
    final foreground = isPrimary ? colors.onPrimary : colors.primary;
    final divider = Theme.of(context).dividerColor;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: divider,
          disabledForegroundColor: colors.onSurface,
          side: borderColor != null ? BorderSide(color: borderColor!) : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
              : Row(
                  key: const ValueKey('label'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: Spacing.sm),
                    ],
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: foreground,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
