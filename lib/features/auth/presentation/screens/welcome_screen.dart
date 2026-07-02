import 'package:flutter/material.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

import '../widgets/social_auth_button.dart';

final class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onLoginTap,
    required this.onSignUpTap,
  });

  final VoidCallback onLoginTap;
  final VoidCallback onSignUpTap;

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth.welcome;
    final colors = context.colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF07070C),
              const Color(0xFF0D0D15),
              const Color(0xFF14141E),
              const Color(0xFF1A1A26),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: context.colors.neonAccent.withAlpha(40),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colors.neonAccent.withAlpha(60),
                            width: 1.5,
                          ),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            context.colors.neonAccent,
                            colors.primary,
                            context.colors.neonAccent,
                          ],
                        ).createShader(bounds),
                        child: const Icon(
                          Icons.motorcycle,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xl),
                Text(
                  t.title,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  t.subtitle,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface.withAlpha(150),
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.06),
                SocialAuthButton(
                  label: t.google,
                  icon: const Icon(Icons.g_mobiledata),
                  onTap: onLoginTap,
                ),
                const SizedBox(height: Spacing.sm),
                SocialAuthButton(
                  label: t.facebook,
                  icon: const Icon(Icons.facebook),
                  onTap: onLoginTap,
                ),
                const SizedBox(height: Spacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: colors.onSurface.withAlpha(20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                      child: Text(
                        t.or,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: colors.onSurface.withAlpha(100),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: colors.onSurface.withAlpha(20),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.lg),
                AppButton(
                  label: t.signUp,
                  onTap: onSignUpTap,
                ),
                const SizedBox(height: Spacing.md),
                TextButton(
                  onPressed: onLoginTap,
                  child: Text(
                    t.logIn,
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colors.neonAccent,
                    ),
                  ),
                ),
                SizedBox(height: Spacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
