import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

import '../cubits/otp_cubit/otp_cubit.dart';
import '../cubits/otp_cubit/otp_state.dart';

final class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({required this.email, super.key});

  final String email;

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

final class _EmailVerificationScreenState
    extends State<EmailVerificationScreen> {
  final _otpCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.email.isNotEmpty) {
      context.read<OtpCubit>().sendEmailOtp(widget.email);
    }
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth.verifyEmail;
    final colors = context.colorScheme;

    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        switch (state) {
          case OtpVerified():
            context.pushReplacement(AppRoute.home);
          default:
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(t.title),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
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
                    Icons.mail_outline,
                    size: 36,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Text(
                  t.description,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface.withAlpha(179),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.email.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: Spacing.sm),
                    child: Text(
                      widget.email,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: colors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: Spacing.lg),
                switch (state) {
                  OtpSending() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  OtpSent(resendCountdownSeconds: _, resendAttemptsRemaining: final remaining) => _buildOtpForm(
                    context,
                    t,
                    remaining,
                  ),
                  OtpResendExhausted() => Text(
                    t.maxAttemptsReached,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: colors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  OtpError(message: final msg) => Padding(
                    padding: const EdgeInsets.only(top: Spacing.md),
                    child: Text(
                      msg,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _ => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpForm(
    BuildContext context,
    Object t,
    int resendAttemptsRemaining,
  ) {
    final colors = context.colorScheme;
    final otpLabel = (t as dynamic).otpLabel as String? ?? 'OTP Code';
    final verifyLabel = (t as dynamic).verify as String? ?? 'Verify';
    final resendLabel = (t as dynamic).resend as String? ?? 'Resend Code';
    final noResendsLeft = (t as dynamic).noResendsLeft as String? ?? 'No resends left';

    return Column(
      children: [
        TextField(
          controller: _otpCtrl,
          decoration: InputDecoration(
            labelText: otpLabel,
            hintText: '123456',
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(Spacing.md),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineMedium?.copyWith(
            letterSpacing: 8,
          ),
        ),
        const SizedBox(height: Spacing.lg),
        AppButton(
          label: verifyLabel,
          onTap: () {
            context.read<OtpCubit>().verifyEmailOtp(
                  widget.email,
                  _otpCtrl.text.trim(),
                );
          },
        ),
        const SizedBox(height: Spacing.md),
        TextButton(
          onPressed: resendAttemptsRemaining > 0
              ? () => context.read<OtpCubit>().sendEmailOtp(widget.email)
              : null,
          child: Text(
            resendAttemptsRemaining > 0
                ? '$resendLabel ($resendAttemptsRemaining)'
                : noResendsLeft,
            style: context.textTheme.bodyMedium?.copyWith(
              color: resendAttemptsRemaining > 0
                  ? colors.primary
                  : colors.onSurface.withAlpha(128),
            ),
          ),
        ),
      ],
    );
  }
}
