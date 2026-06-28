import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/constants/app_validation.dart';
import 'package:moto_orbito/core/constants/app_constants.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

import '../cubit/otp_cubit.dart';
import '../cubit/otp_state.dart';

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
    context.read<OtpCubit>().sendEmailOtp(widget.email);
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth.verifyEmail;
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        switch (state) {
          case OtpVerified():
            context.pushReplacement(AppRoute.phoneOtp, extra: widget.email);
          default:
            break;
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(t.title)),
          body: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Spacing.xl),
                Text(
                  t.description,
                  style: context.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
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
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  OtpError(messageKey: final msg) => Padding(
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
    return Column(
      children: [
        TextField(
          controller: _otpCtrl,
          decoration: InputDecoration(
            labelText: AppConstants.otpCodeLabel,
            hintText: AppValidation.otpHint,
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        const SizedBox(height: Spacing.lg),
        AppButton(
          label: (t as dynamic).verify as String? ?? 'Verify',
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
                ? '${(t as dynamic).resend as String? ?? 'Resend Code'} ($resendAttemptsRemaining left)'
                : (t as dynamic).noResendsLeft as String? ?? 'No resends left',
          ),
        ),
      ],
    );
  }
}
