import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/constants/app_validation.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';
import 'package:moto_orbito/core/widgets/app_text_field.dart';

import '../cubit/forgot_password_cubit.dart';
import '../cubit/forgot_password_state.dart';

final class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

final class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        final t = context.t.auth.forgotPassword;
        return switch (state) {
          ForgotPasswordSent() => _buildSuccess(context, t.success),
          _ => _buildForm(context, t),
        };
      },
    );
  }

  Widget _buildSuccess(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.auth.forgotPassword.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                size: 64,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                message,
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, dynamic t) {
    return Scaffold(
      appBar: AppBar(title: Text(t.title as String)),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.lg),
        child: Form(
          key: _formKey,
          child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
            builder: (context, state) {
              final isLoading = switch (state) {
                ForgotPasswordSending() => true,
                _ => false,
              };
              final errorMessage = switch (state) {
                ForgotPasswordError(messageKey: final msg) => msg,
                _ => null,
              };
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Spacing.lg),
                  Text(
                    t.description as String,
                    style: context.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: Spacing.lg),
                  AppTextField(
                    label: t.email as String,
                    hint: t.email as String,
                    controller: _emailCtrl,
                    validator: (v) =>
                        v == null || !v.contains('@')
                            ? AppValidation.emailRequired
                            : null,
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: Spacing.md),
                    Text(
                      errorMessage,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: Spacing.xl),
                  AppButton(
                    label: t.send as String,
                    isLoading: isLoading,
                    onTap: () {
                      if (_formKey.currentState?.validate() == true) {
                        context.read<ForgotPasswordCubit>().sendResetEmail(
                              _emailCtrl.text.trim(),
                            );
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
