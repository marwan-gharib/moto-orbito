import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/constants/app_failure_keys.dart';
import 'package:moto_orbito/core/constants/app_validation.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';
import 'package:moto_orbito/core/widgets/app_text_field.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

final class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

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
    final t = context.t.auth.login;
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        switch (state) {
          case LoginSuccess(user: final user):
            context.read<AuthCubit>().setUser(user);
            context.pushReplacement(AppRoute.home);
          case LoginError(messageKey: AppFailureKeys.emailNotVerified):
            context.pushReplacement(AppRoute.verifyEmail,
                extra: _emailCtrl.text.trim());
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = switch (state) { LoginLoading() => true, _ => false };
        final errorMessage = switch (state) {
          LoginError(messageKey: final msg) => msg,
          _ => null,
        };
        return Scaffold(
          appBar: AppBar(title: Text(t.title)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Spacing.lg),
                  AppTextField(
                    label: t.email,
                    hint: t.email,
                    controller: _emailCtrl,
                    validator: (v) =>
                        v == null || !v.contains('@')
                            ? AppValidation.emailRequired
                            : null,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppTextField(
                    label: t.password,
                    hint: t.password,
                    controller: _passwordCtrl,
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.isEmpty
                            ? AppValidation.passwordRequired
                            : null,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoute.forgotPassword),
                      child: Text(t.forgotPassword),
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.md),
                      child: Text(
                        errorMessage,
                        style: context.textTheme.bodySmall
                            ?.copyWith(color: context.colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  AppButton(
                    label: t.submit,
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
