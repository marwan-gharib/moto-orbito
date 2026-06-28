import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

abstract final class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, context.colors.success);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, context.colorScheme.error);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, context.colors.warning);
  }

  static void _show(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: context.textTheme.bodyMedium),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.all(20),
        ),
      );
  }
}
