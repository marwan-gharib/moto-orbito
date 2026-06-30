import 'package:flutter/material.dart';
import 'app_colors.dart';

@immutable
final class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.success,
    required this.warning,
    required this.skeleton,
    required this.neonAccent,
    required this.surfaceCard,
  });

  factory AppColorsExtension.light() => const AppColorsExtension(
    success: AppColors.successLight,
    warning: AppColors.warningLight,
    skeleton: AppColors.skeletonLight,
    neonAccent: AppColors.neonOrange,
    surfaceCard: AppColors.surfaceLight,
  );

  factory AppColorsExtension.dark() => const AppColorsExtension(
    success: AppColors.successDark,
    warning: AppColors.warningDark,
    skeleton: AppColors.skeletonDark,
    neonAccent: AppColors.neonOrangeLight,
    surfaceCard: AppColors.cardDark,
  );

  final Color success;
  final Color warning;
  final Color skeleton;
  final Color neonAccent;
  final Color surfaceCard;

  @override
  AppColorsExtension copyWith({
    Color? success,
    Color? warning,
    Color? skeleton,
    Color? neonAccent,
    Color? surfaceCard,
  }) {
    return AppColorsExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      skeleton: skeleton ?? this.skeleton,
      neonAccent: neonAccent ?? this.neonAccent,
      surfaceCard: surfaceCard ?? this.surfaceCard,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
      neonAccent: Color.lerp(neonAccent, other.neonAccent, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
    );
  }
}
