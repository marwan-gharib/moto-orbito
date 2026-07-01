import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';
import 'package:moto_orbito/core/widgets/app_text_field.dart';

import '../cubits/forgot_password_cubit/forgot_password_cubit.dart';
import '../cubits/forgot_password_cubit/forgot_password_state.dart';

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
    final t = context.t.auth.forgotPassword;
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return switch (state) {
          ForgotPasswordSent() => _buildSuccess(context, t.success),
          _ => _buildForm(context, t),
        };
      },
    );
  }

  Widget _buildSuccess(BuildContext context, String message) {
    final colors = context.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.t.auth.forgotPassword.title),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primary.withAlpha(25),
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 48,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                message,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, Object t) {
    final colors = context.colorScheme;
    final title = (t as dynamic).title as String;
    final description = (t as dynamic).description as String;
    final email = (t as dynamic).email as String;
    final send = (t as dynamic).send as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
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
                ForgotPasswordError(message: final msg) => msg,
                _ => null,
              };
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Spacing.xl),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary.withAlpha(25),
                    ),
                    child: Icon(
                      Icons.lock_reset,
                      size: 36,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Text(
                    description,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: colors.onSurface.withAlpha(179),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.lg),
                  AppTextField(
                    label: email,
                    hint: email,
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        v == null || !v.contains('@')
                            ? context.t.errors.fieldRequired
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
                    label: send,
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
