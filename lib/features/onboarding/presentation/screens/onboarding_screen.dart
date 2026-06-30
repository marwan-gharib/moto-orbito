import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';
import 'package:moto_orbito/core/widgets/error_state_widget.dart';

import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_slide.dart';

final class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

final class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<OnboardingCubit>().checkOnboardingStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state is OnboardingComplete) {
          context.go(AppRoute.welcome);
        }
      },
      builder: (context, state) {
        final currentPage = switch (state) {
          OnboardingInProgress(currentPage: final page) => page,
          _ => 0,
        };

        return switch (state) {
          OnboardingInProgress() => _buildContent(context, currentPage),
          OnboardingError(messageKey: final key) => Scaffold(
            body: SafeArea(
              child: ErrorStateWidget(
                messageKey: key,
                onRetry: () =>
                    context.read<OnboardingCubit>().completeOnboarding(),
              ),
            ),
          ),
          OnboardingComplete() ||
          OnboardingInitial() => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildContent(BuildContext context, int page) {
    final t = context.t.onboarding;
    final isLastPage = page >= OnboardingCubit.totalPages - 1;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: OnboardingCubit.totalPages,
                  onPageChanged: (index) {
                    context.read<OnboardingCubit>().setPage(index);
                  },
                  itemBuilder: (_, index) => OnboardingSlide(page: index),
                ),
              ),
              OnboardingPageIndicator(
                currentPage: page,
                totalPages: OnboardingCubit.totalPages,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  Spacing.lg,
                  Spacing.lg,
                  Spacing.lg,
                  Spacing.xl,
                ),
                child: AppButton(
                  label: isLastPage ? t.getStarted : t.next,
                  onTap: () {
                    if (!isLastPage) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                      context.read<OnboardingCubit>().nextPage();
                    } else {
                      context.read<OnboardingCubit>().completeOnboarding();
                    }
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: padding.top + Spacing.sm,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isLastPage ? 0.0 : 1.0,
              child: IgnorePointer(
                ignoring: isLastPage,
                child: TextButton(
                  onPressed: () =>
                      context.read<OnboardingCubit>().completeOnboarding(),
                  child: Text(
                    t.skip,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
