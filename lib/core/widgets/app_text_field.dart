import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/spacing.dart';

final class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.focusBorderColor,
    this.filled = false,
    this.fillColor,
    super.key,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Color? focusBorderColor;
  final bool filled;
  final Color? fillColor;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

final class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = context.colorScheme.onSurface.withAlpha(30);
    final accentColor = widget.focusBorderColor ?? context.colorScheme.primary;

    return TextFormField(
      focusNode: _focusNode,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: widget.controller,
      validator: widget.validator,
      obscureText: _obscured,
      keyboardType: widget.keyboardType,
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        labelStyle: context.textTheme.bodyMedium?.copyWith(
          color: _focusNode.hasFocus
              ? accentColor
              : context.colorScheme.onSurface.withAlpha(128),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(
                  left: Spacing.md,
                  right: Spacing.sm,
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: _focusNode.hasFocus
                        ? accentColor
                        : context.colorScheme.onSurface.withAlpha(128),
                    size: 20,
                  ),
                  child: widget.prefixIcon!,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
          minHeight: 24,
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () => setState(() => _obscured = !_obscured),
                icon: Icon(
                  _obscured
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                ),
                color: context.colorScheme.onSurface.withAlpha(128),
              )
            : null,
        filled: widget.filled,
        fillColor: widget.fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colorScheme.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.md,
        ),
      ),
    );
  }
}
