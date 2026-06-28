import 'package:flutter/material.dart';
import 'package:moto_orbito/core/theme/app_text_styles.dart';

import 'app_colors.dart';
import 'app_colors_extension.dart';

final class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return _theme(
      brightness: Brightness.light,
      colorsExtension: AppColorsExtension.light(),
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.onPrimaryLight,
        secondary: AppColors.primaryVariantLight,
        onSecondary: AppColors.onPrimaryLight,
        error: AppColors.errorLight,
        onError: AppColors.onErrorLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      dividerColor: AppColors.dividerLight,
    );
  }

  static ThemeData dark() {
    return _theme(
      brightness: Brightness.dark,
      colorsExtension: AppColorsExtension.dark(),
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: AppColors.onPrimaryDark,
        secondary: AppColors.primaryVariantDark,
        onSecondary: AppColors.onPrimaryDark,
        error: AppColors.errorDark,
        onError: AppColors.onErrorDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      dividerColor: AppColors.dividerDark,
    );
  }

  static ThemeData _theme({
    required Brightness brightness,
    required AppColorsExtension colorsExtension,
    required ColorScheme colorScheme,
    required Color scaffoldBackgroundColor,
    required Color dividerColor,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: colorScheme,
      dividerColor: dividerColor,
      textTheme: AppTextStyles.build(colorScheme.onSurface),
      extensions: <ThemeExtension<dynamic>>[colorsExtension],
    );
  }
}
