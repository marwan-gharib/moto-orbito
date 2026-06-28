import 'package:flutter/material.dart';

@immutable
final class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  const AppColorsExtension({
    required this.primary,
    required this.primaryVariant,
    required this.onPrimary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.error,
    required this.onError,
    required this.success,
    required this.warning,
    required this.divider,
    required this.skeleton,
  });

  factory AppColorsExtension.light() => const AppColorsExtension(
    primary: Color(0xFFFF6B00),
    primaryVariant: Color(0xFFCC5500),
    onPrimary: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF1A1A1A),
    background: Color(0xFFF5F5F5),
    onBackground: Color(0xFF1A1A1A),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    success: Color(0xFF388E3C),
    warning: Color(0xFFF57C00),
    divider: Color(0xFFE0E0E0),
    skeleton: Color(0xFFE0E0E0),
  );

  factory AppColorsExtension.dark() => const AppColorsExtension(
    primary: Color(0xFFFF8C33),
    primaryVariant: Color(0xFFFF6B00),
    onPrimary: Color(0xFF1A1A1A),
    surface: Color(0xFF1A1A1A),
    onSurface: Color(0xFFF5F5F5),
    background: Color(0xFF121212),
    onBackground: Color(0xFFE0E0E0),
    error: Color(0xFFEF9A9A),
    onError: Color(0xFF1A1A1A),
    success: Color(0xFFA5D6A7),
    warning: Color(0xFFFFCC80),
    divider: Color(0xFF2C2C2C),
    skeleton: Color(0xFF2C2C2C),
  );

  final Color primary;
  final Color primaryVariant;
  final Color onPrimary;
  final Color surface;
  final Color onSurface;
  final Color background;
  final Color onBackground;
  final Color error;
  final Color onError;
  final Color success;
  final Color warning;
  final Color divider;
  final Color skeleton;

  @override
  AppColorsExtension copyWith({
    Color? primary,
    Color? primaryVariant,
    Color? onPrimary,
    Color? surface,
    Color? onSurface,
    Color? background,
    Color? onBackground,
    Color? error,
    Color? onError,
    Color? success,
    Color? warning,
    Color? divider,
    Color? skeleton,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      onPrimary: onPrimary ?? this.onPrimary,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      divider: divider ?? this.divider,
      skeleton: skeleton ?? this.skeleton,
    );
  }

  @override
  AppColorsExtension lerp(ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryVariant: Color.lerp(primaryVariant, other.primaryVariant, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      skeleton: Color.lerp(skeleton, other.skeleton, t)!,
    );
  }
}
