import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/utils/enums.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

final class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth.welcome;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Icon(
                Icons.motorcycle,
                size: 100,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                t.title,
                style: context.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.sm),
              Text(
                t.subtitle,
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              AppButton(
                label: t.google,
                onTap: () {},
              ),
              const SizedBox(height: Spacing.sm),
              AppButton(
                label: t.facebook,
                variant: AppButtonVariant.secondary,
                onTap: () {},
              ),
              const SizedBox(height: Spacing.lg),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                    child: Text(
                      t.or,
                      style: context.textTheme.bodyMedium,
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: Spacing.lg),
              AppButton(
                label: t.signUp,
                onTap: () => context.push(AppRoute.signUp),
              ),
              const SizedBox(height: Spacing.sm),
              TextButton(
                onPressed: () => context.push(AppRoute.login),
                child: Text(t.logIn),
              ),
              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
