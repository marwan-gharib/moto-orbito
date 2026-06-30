import 'package:flutter/material.dart';
import 'package:moto_orbito/core/constants/assest.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';

const imagePaths = <String>[
  Assest.onboarding1,
  Assest.onboarding2,
  Assest.onboarding3,
];

final class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({required this.page, super.key});

  final int page;

  @override
  Widget build(BuildContext context) {
    final t = context.t.onboarding;
    final textTheme = context.textTheme;
    final colors = context.colorScheme;
    final imgPath = imagePaths[page];

    final title = switch (page) {
      0 => t.slide1.title,
      1 => t.slide2.title,
      _ => t.slide3.title,
    };

    final description = switch (page) {
      0 => t.slide1.description,
      1 => t.slide2.description,
      _ => t.slide3.description,
    };

    return Stack(
      children: [
        Positioned.fill(child: Image.asset(imgPath, fit: BoxFit.cover)),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  context.theme.scaffoldBackgroundColor.withValues(alpha: 0.0),
                  context.theme.scaffoldBackgroundColor.withValues(alpha: 0.93),
                  context.theme.scaffoldBackgroundColor,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: Spacing.lg,
          right: Spacing.lg,
          bottom: Spacing.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.onSurface,
                  height: 1.2,
                ),
              ),
              SizedBox(height: Spacing.sm),
              Text(
                description,
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.78),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
