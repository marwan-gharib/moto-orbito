import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

import '../cubit/auth_cubit.dart';
import '../cubit/sign_up_cubit.dart';
import '../cubit/sign_up_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/profile_image_picker.dart';

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
  final _confirmPasswordCtrl = TextEditingController();

  Uint8List? _profileImageBytes;
  String? _profileImageName;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colorScheme;

    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        switch (state) {
          case SignUpSuccess(user: final user):
            context.read<AuthCubit>().setUser(user);
            context.pushReplacement(AppRoute.verifyEmail,
                extra: _emailCtrl.text.trim());
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading =
            switch (state) { SignUpLoading() => true, _ => false };
        final errorMessage = switch (state) {
          SignUpError(messageKey: final msg) => msg,
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
                        height: MediaQuery.of(context).size.height * 0.04,
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
                      const SizedBox(height: Spacing.md),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colors.neonAccent.withAlpha(60),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.motorcycle,
                          size: 36,
                          color: context.colors.neonAccent,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      Text(
                        t.auth.signUp.title,
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),
                      Center(
                        child: ProfileImagePicker(
                          imageBytes: _profileImageBytes,
                          onImagePicked: (bytes, name) {
                            setState(() {
                              _profileImageBytes = bytes;
                              _profileImageName = name;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),
                      AuthTextField(
                        label: t.auth.signUp.fullName,
                        hint: t.auth.signUp.fullName,
                        controller: _nameCtrl,
                        icon: Icons.person_outline,
                        validator: (v) =>
                            v == null || v.trim().isEmpty
                                ? t.errors.fieldRequired
                                : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AuthTextField(
                        label: t.auth.signUp.email,
                        hint: t.auth.signUp.email,
                        controller: _emailCtrl,
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) =>
                            v == null || !v.contains('@')
                                ? t.errors.fieldRequired
                                : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AuthTextField(
                        label: t.auth.signUp.password,
                        hint: '********',
                        controller: _passwordCtrl,
                        icon: Icons.lock_outlined,
                        obscureText: true,
                        validator: (v) =>
                            v == null || v.length < 8
                                ? t.errors.fieldRequired
                                : null,
                      ),
                      const SizedBox(height: Spacing.md),
                      AuthTextField(
                        label: t.auth.signUp.confirmPassword,
                        hint: '********',
                        controller: _confirmPasswordCtrl,
                        icon: Icons.lock_outlined,
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return t.errors.fieldRequired;
                          }
                          if (v != _passwordCtrl.text) {
                            return t.auth.signUp.passwordMismatch;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Spacing.lg),
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
                        label: t.auth.signUp.submit,
                        isLoading: isLoading,
                        onTap: () {
                          if (_formKey.currentState?.validate() == true) {
                            context.read<SignUpCubit>().signUp(
                                  email: _emailCtrl.text.trim(),
                                  password: _passwordCtrl.text,
                                  fullName: _nameCtrl.text.trim(),
                                  profilePicturePath: _profileImageName,
                                  profilePictureBytes: _profileImageBytes,
                                );
                          }
                        },
                      ),
                      const SizedBox(height: Spacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            t.auth.login.dontHaveAccount,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: colors.onSurface.withAlpha(150),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                context.pushReplacement(AppRoute.login),
                            child: Text(
                              t.auth.welcome.logIn,
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
