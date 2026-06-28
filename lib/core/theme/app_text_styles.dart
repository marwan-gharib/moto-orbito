import 'package:flutter/material.dart';

TextTheme buildAppTextTheme(Color onSurface) {
  const baseFamily = 'Roboto';
  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: baseFamily,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    headlineMedium: TextStyle(
      fontFamily: baseFamily,
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: onSurface,
    ),
    titleLarge: TextStyle(
      fontFamily: baseFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
    bodyLarge: TextStyle(
      fontFamily: baseFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: onSurface,
    ),
    bodyMedium: TextStyle(
      fontFamily: baseFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: onSurface,
    ),
    labelLarge: TextStyle(
      fontFamily: baseFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: onSurface,
    ),
  );
}
