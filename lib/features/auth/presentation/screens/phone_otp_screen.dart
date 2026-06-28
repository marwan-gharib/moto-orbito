import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_orbito/core/constants/app_validation.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/router/routes.dart';
import 'package:moto_orbito/core/theme/spacing.dart';
import 'package:moto_orbito/core/utils/enums.dart';
import 'package:moto_orbito/core/widgets/app_button.dart';

import '../cubit/otp_cubit.dart';
import '../cubit/otp_state.dart';

final class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({required this.phone, super.key});

  final String phone;

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

final class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  final _otpCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<OtpCubit>().sendPhoneOtp(widget.phone);
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t.auth.verifyPhone;
    return BlocConsumer<OtpCubit, OtpState>(
      listener: (context, state) {
        switch (state) {
          case OtpVerified():
            context.pushReplacement(AppRoute.profileSetup);
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
                const SizedBox(height: Spacing.md),
                Text(
                  'Or tap Skip to do this later.',
                  style: context.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.lg),
                switch (state) {
                  OtpSending() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  OtpSent() => Column(
                    children: [
                      TextField(
                        controller: _otpCtrl,
                        decoration: InputDecoration(
                          labelText: 'OTP Code',
                          hintText: AppValidation.otpHint,
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                      const SizedBox(height: Spacing.lg),
                      AppButton(
                        label: t.verify,
                        onTap: () {
                          context.read<OtpCubit>().verifyPhoneOtp(
                                widget.phone,
                                _otpCtrl.text.trim(),
                              );
                        },
                      ),
                    ],
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
                const SizedBox(height: Spacing.md),
                AppButton(
                  label: t.skip,
                  variant: AppButtonVariant.secondary,
                  onTap: () {
                    context.pushReplacement(AppRoute.profileSetup);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
