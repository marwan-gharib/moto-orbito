import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/i18n/strings.g.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';
import 'package:moto_orbito/core/widgets/app_snack_bar.dart';

import '../view_models/user_view_model.dart';
import '../cubits/sign_up_cubit/sign_up_cubit.dart';
import '../cubits/sign_up_cubit/sign_up_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_checklist.dart';
import '../widgets/profile_image_picker.dart';

final class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    required this.onSignUpSuccess,
    this.onEmailUnverified,
    this.onLoginTap,
  });

  final void Function(UserViewModel user, String email) onSignUpSuccess;
  final void Function(String email)? onEmailUnverified;
  final VoidCallback? onLoginTap;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(_onPasswordChanged);
    _passwordFocusNode.addListener(_onPasswordFocusChanged);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.removeListener(_onPasswordChanged);
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _passwordFocusNode.removeListener(_onPasswordFocusChanged);
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  void _onPasswordFocusChanged() {
    setState(() {});
  }

  void _onSignUp(SignUpCubit cubit) {
    if (_formKey.currentState?.validate() != true) return;
    cubit.signUp(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      fullName: _nameCtrl.text.trim(),
      username: _usernameCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colorScheme;

    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {
        switch (state) {
          case SignUpSuccess(user: final user):
            widget.onSignUpSuccess(user, _emailCtrl.text.trim());
          case SignUpEmailUnverified():
            widget.onEmailUnverified?.call(_emailCtrl.text.trim());
          case SignUpError(message: final msg):
            AppSnackBar.showError(context, msg);
          case SignUpUsernameTaken():
            AppSnackBar.showError(
              context,
              context.t.auth.signUp.usernameTaken,
            );
          default:
            break;
        }
      },
      builder: (context, state) {
        final isLoading = switch (state) {
          SignUpLoading() => true,
          _ => false,
        };

        final password = _passwordCtrl.text;
        final isPasswordFocused = _passwordFocusNode.hasFocus;

        final requirements = _buildPasswordRequirements(t, password);

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
                      Center(
                        child: BlocBuilder<SignUpCubit, SignUpState>(
                          builder: (context, _) {
                            final cubit = context.read<SignUpCubit>();
                            return ProfileImagePicker(
                              imageBytes: cubit.profileImageBytes,
                              onImagePicked: cubit.setProfileImage,
                            );
                          },
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
                        label: t.auth.signUp.username,
                        hint: t.auth.signUp.username,
                        controller: _usernameCtrl,
                        icon: Icons.alternate_email,
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
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return t.errors.fieldRequired;
                          }
                          if (!EmailValidator.validate(v.trim())) {
                            return t.auth.signUp.invalidEmail;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Spacing.md),
                      AuthTextField(
                        label: t.auth.signUp.password,
                        hint: t.auth.signUp.passwordHint,
                        controller: _passwordCtrl,
                        icon: Icons.lock_outlined,
                        obscureText: true,
                        focusNode: _passwordFocusNode,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return t.errors.fieldRequired;
                          }
                          final missing = _getMissingRequirements(v);
                          if (missing.isNotEmpty) {
                            return t.auth.signUp.passwordWeak;
                          }
                          return null;
                        },
                      ),
                      if (isPasswordFocused && requirements.any((r) => !r.isMet))
                        PasswordChecklist(requirements: requirements),
                      const SizedBox(height: Spacing.md),
                      AuthTextField(
                        label: t.auth.signUp.confirmPassword,
                        hint: t.auth.signUp.confirmPasswordHint,
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
                      AppButton(
                        label: t.auth.signUp.submit,
                        isLoading: isLoading,
                        onTap: () => _onSignUp(context.read<SignUpCubit>()),
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
                            onPressed: widget.onLoginTap,
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

  List<PasswordRequirement> _buildPasswordRequirements(Translations t, String password) {
    return [
      PasswordRequirement(
        label: t.auth.signUp.passwordMinLength,
        isMet: password.length >= 8,
      ),
      PasswordRequirement(
        label: t.auth.signUp.passwordUppercase,
        isMet: password.contains(RegExp(r'[A-Z]')),
      ),
      PasswordRequirement(
        label: t.auth.signUp.passwordLowercase,
        isMet: password.contains(RegExp(r'[a-z]')),
      ),
      PasswordRequirement(
        label: t.auth.signUp.passwordNumber,
        isMet: password.contains(RegExp(r'[0-9]')),
      ),
      PasswordRequirement(
        label: t.auth.signUp.passwordSpecial,
        isMet: password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ),
    ];
  }

  List<String> _getMissingRequirements(String password) {
    final missing = <String>[];
    if (password.length < 8) missing.add('minLength');
    if (!password.contains(RegExp(r'[A-Z]'))) missing.add('uppercase');
    if (!password.contains(RegExp(r'[a-z]'))) missing.add('lowercase');
    if (!password.contains(RegExp(r'[0-9]'))) missing.add('number');
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      missing.add('special');
    }
    return missing;
  }
}
