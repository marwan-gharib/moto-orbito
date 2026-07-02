import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

import '../view_models/user_view_model.dart';
import '../cubits/login_cubit/login_cubit.dart';
import '../cubits/login_cubit/login_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_auth_button.dart';

final class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
    this.onSignUpTap,
    this.onForgotPasswordTap,
  });

  final void Function(UserViewModel user) onLoginSuccess;
  final VoidCallback? onSignUpTap;
  final VoidCallback? onForgotPasswordTap;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colorScheme;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        switch (state) {
          case LoginSuccess(user: final user):
            widget.onLoginSuccess(user);
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = switch (state) {
          LoginLoading() => true,
          _ => false,
        };
        final errorMessage = switch (state) {
          LoginError(message: final msg) => msg,
          _ => null,
        };

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF07070C),
                  Color(0xFF0D0D15),
                  Color(0xFF14141E),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.06,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: colors.onSurface.withAlpha(10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              onPressed: () => context.pop(),
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: colors.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colors.neonAccent.withAlpha(60),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.colors.neonAccent.withAlpha(25),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.motorcycle,
                          size: 40,
                          color: context.colors.neonAccent,
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),
                      Text(
                        t.auth.login.title,
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),
                      AuthTextField(
                        label: t.auth.login.email,
                        hint: t.auth.login.email,
                        controller: _emailCtrl,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => v == null || !v.contains('@')
                            ? t.errors.fieldRequired
                            : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AuthTextField(
                        label: t.auth.login.password,
                        hint: t.auth.login.passwordHint,
                        controller: _passwordCtrl,
                        icon: Icons.lock_outlined,
                        obscureText: true,
                        validator: (v) => v == null || v.isEmpty
                            ? t.errors.fieldRequired
                            : null,
                      ),
                      const SizedBox(height: Spacing.sm),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: widget.onForgotPasswordTap,
                          child: Text(
                            t.auth.login.forgotPassword,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: context.colors.neonAccent,
                            ),
                          ),
                        ),
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: Spacing.md),
                          child: Container(
                            padding: const EdgeInsets.all(Spacing.sm),
                            decoration: BoxDecoration(
                              color: colors.error.withAlpha(20),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              errorMessage,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: colors.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      AppButton(
                        label: t.auth.login.submit,
                        isLoading: isLoading,
                        onTap: () {
                          if (_formKey.currentState?.validate() == true) {
                            context.read<LoginCubit>().login(
                              email: _emailCtrl.text.trim(),
                              password: _passwordCtrl.text,
                            );
                          }
                        },
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.md,
                            ),
                            child: Text(
                              t.auth.welcome.or,
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
                      SocialAuthButton(
                        label: t.auth.welcome.google,
                        icon: const Icon(Icons.g_mobiledata),
                        onTap: () {
                          context.read<LoginCubit>().signInWithGoogle();
                        },
                      ),
                      const SizedBox(height: Spacing.sm),
                      SocialAuthButton(
                        label: t.auth.welcome.facebook,
                        icon: const Icon(Icons.facebook),
                        onTap: () {
                          context.read<LoginCubit>().signInWithFacebook();
                        },
                      ),
                      const SizedBox(height: Spacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.auth.signUp.haveAccount,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface.withAlpha(150),
                            ),
                          ),
                          TextButton(
                            onPressed: widget.onSignUpTap,
                            child: Text(
                              t.auth.welcome.signUp,
                              style: context.textTheme.labelLarge?.copyWith(
                                color: context.colors.neonAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Spacing.xxl),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
