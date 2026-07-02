import 'package:flutter/material.dart';
import 'package:moto_orbito/core/extensions/context_extensions.dart';
import 'package:moto_orbito/core/widgets/app_text_field.dart';

final class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.suffixWidget,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return AppTextField(
      label: label,
      hint: hint,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      focusNode: focusNode,
      onChanged: onChanged,
      suffixWidget: suffixWidget,
      prefixIcon: Icon(icon),
      focusBorderColor: context.colors.neonAccent,
      filled: true,
      fillColor: colors.onSurface.withAlpha(8),
    );
  }
}
