import 'package:flutter/material.dart';

import 'app_colors_extension.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final colors = AppColorsExtension.light();
    return _theme(Brightness.light, colors);
  }

  static ThemeData dark() {
    final colors = AppColorsExtension.dark();
    return _theme(Brightness.dark, colors);
  }

  static ThemeData _theme(Brightness brightness, AppColorsExtension colors) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.primaryVariant,
        onSecondary: colors.onPrimary,
        error: colors.error,
        onError: colors.onError,
        surface: colors.surface,
        onSurface: colors.onSurface,
      ),
      textTheme: buildAppTextTheme(colors.onSurface),
      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}
