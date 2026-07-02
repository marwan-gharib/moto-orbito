import 'package:flutter/material.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';

final class PasswordRequirement {
  const PasswordRequirement({
    required this.label,
    required this.isMet,
  });

  final String label;
  final bool isMet;
}

final class PasswordChecklist extends StatelessWidget {
  const PasswordChecklist({
    required this.requirements,
    super.key,
  });

  final List<PasswordRequirement> requirements;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Spacing.xs),
        ...requirements.map(
          (req) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  req.isMet ? Icons.check_circle : Icons.circle_outlined,
                  size: 14,
                  color: req.isMet
                      ? context.colors.success
                      : colors.onSurface.withAlpha(128),
                ),
                const SizedBox(width: 6),
                Text(
                  req.label,
                  style: context.textTheme.bodySmall?.copyWith(
                    decoration: req.isMet ? TextDecoration.lineThrough : null,
                    color: req.isMet
                        ? context.colors.success
                        : colors.onSurface.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
