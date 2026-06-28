import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';

final class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const _slideIcons = <int, IconData>{
    0: Icons.groups,
    1: Icons.satellite_alt,
    2: Icons.auto_awesome,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return switch (state) {
          OnboardingInProgress(currentPage: final page) => _buildContent(
            context,
            page,
          ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildContent(BuildContext context, int page) {
    final t = context.t.onboarding;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () =>
                      context.read<OnboardingCubit>().completeOnboarding(),
                  child: Text(t.skip),
                ),
              ),
              const Spacer(flex: 2),
              Icon(
                _slideIcons[page] ?? Icons.circle,
                size: 120,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: Spacing.xl),
              Text(
                _slideTitle(t, page),
                style: context.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.md),
              Text(
                _slideDescription(t, page),
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              _PageIndicator(currentPage: page),
              const SizedBox(height: Spacing.xl),
              AppButton(
                label: page < 2 ? t.next : t.getStarted,
                onTap: () {
                  if (page < 2) {
                    context.read<OnboardingCubit>().nextPage();
                  } else {
                    context
                        .read<OnboardingCubit>()
                        .completeOnboarding();
                  }
                },
              ),
              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  String _slideTitle(covariant dynamic t, int page) {
    return switch (page) {
      0 => t.slide1.title as String,
      1 => t.slide2.title as String,
      _ => t.slide3.title as String,
    };
  }

  String _slideDescription(covariant dynamic t, int page) {
    return switch (page) {
      0 => t.slide1.description as String,
      1 => t.slide2.description as String,
      _ => t.slide3.description as String,
    };
  }
}

final class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage});

  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: Spacing.xs),
          width: i == currentPage ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: i == currentPage
                ? context.colorScheme.primary
                : context.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}
