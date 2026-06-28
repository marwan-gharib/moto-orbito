import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
final class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.success,
    required this.warning,
    required this.skeleton,
  });

  factory AppColorsExtension.light() => const AppColorsExtension(
    success: AppColors.successLight,
    warning: AppColors.warningLight,
    skeleton: AppColors.skeletonLight,
  );

  factory AppColorsExtension.dark() => const AppColorsExtension(
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    skeleton: AppColors.skeletonDark,
  );

  final Color success;
  final Color warning;
  final Color skeleton;

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? warning,
    Color? skeleton,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      skeleton: skeleton ?? this.skeleton,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
    );
  }
}
