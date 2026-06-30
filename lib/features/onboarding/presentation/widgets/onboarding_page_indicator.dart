import 'package:flutter/material.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';

final class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    required this.currentPage,
    required this.totalPages,
    super.key,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return SizedBox(
      height: Spacing.lg,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalPages, (i) {
          final isActive = i == currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.symmetric(horizontal: Spacing.xs),
            width: isActive ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Spacing.xs),
              color: isActive
                  ? colors.primary
                  : colors.outline.withValues(alpha: 0.31),
            ),
          );
        }),
      ),
    );
  }
}
