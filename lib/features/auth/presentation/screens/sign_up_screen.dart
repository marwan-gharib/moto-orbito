import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/constants/app_validation.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';
import 'package:moto_orbito/core/widgets/app_text_field.dart';

import '../cubit/sign_up_cubit.dart';
import '../cubit/sign_up_state.dart';

final class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth.signUp;
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        switch (state) {
          case SignUpSuccess():
            context.pushReplacement(AppRoute.verifyEmail);
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = switch (state) { SignUpLoading() => true, _ => false };
        final errorMessage = switch (state) {
          SignUpError(messageKey: final msg) => msg,
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
                    label: t.fullName,
                    hint: t.fullName,
                    controller: _nameCtrl,
                    validator: (v) =>
                        v == null || v.isEmpty
                            ? AppValidation.nameRequired
                            : null,
                  ),
                  const SizedBox(height: Spacing.md),
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
                    hint: AppValidation.minPasswordLength,
                    controller: _passwordCtrl,
                    obscureText: true,
                    validator: (v) =>
                        v == null || v.length < 8
                            ? AppValidation.minPasswordLength
                            : null,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppTextField(
                    label: t.phone,
                    hint: AppValidation.phoneHint,
                    controller: _phoneCtrl,
                    validator: (v) =>
                        v == null || v.isEmpty
                            ? AppValidation.phoneRequired
                            : null,
                  ),
                  const SizedBox(height: Spacing.xl),
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
                        context.read<SignUpCubit>().signUp(
                              email: _emailCtrl.text.trim(),
                              password: _passwordCtrl.text,
                              fullName: _nameCtrl.text.trim(),
                              phone: _phoneCtrl.text.trim(),
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
