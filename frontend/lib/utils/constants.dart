import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF93000B);
  static const primaryContainer = Color(0xFFB91C1C);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryFixed = Color(0xFFFFDAD6);
  static const onPrimaryFixed = Color(0xFF410002);
  static const onPrimaryContainer = Color(0xFFFFCDC7);
  static const onPrimaryFixedVariant = Color(0xFF93000B);
  static const secondary = Color(0xFF515F74);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFD5E3FC);
  static const onSecondaryContainer = Color(0xFF57657A);
  static const onSecondaryFixedVariant = Color(0xFF3A485B);
  static const tertiary = Color(0xFF444749);
  static const background = Color(0xFFF9F9FF);
  static const surface = Color(0xFFF9F9FF);
  static const surfaceContainer = Color(0xFFE7EEFF);
  static const surfaceContainerLow = Color(0xFFF0F3FF);
  static const surfaceContainerHigh = Color(0xFFDEE8FF);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFD8E3FB);
  static const onSurface = Color(0xFF111C2D);
  static const onSurfaceVariant = Color(0xFF5B403D);
  static const outline = Color(0xFF8F6F6C);
  static const outlineVariant = Color(0xFFE4BEB9);
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onError = Color(0xFFFFFFFF);
  static const success = Color(0xFF388E3C);
  static const warning = Color(0xFFFFA000);
  static const text = Color(0xFF111C2D);
  static const textLight = Color(0xFF5B403D);
}

class AppConstants {
  static const String appName = 'MedFoot';
  static const String apiBaseUrl = 'https://medfoot.ramjlimited.com/api';
}

class AppTypography {
  static const h1 = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.02,
  );

  static const h2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.02,
  );

  static const h3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.01,
  );

  static const bodyLg = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const bodyMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const bodySm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const labelBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.05,
  );

  static const labelMd = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: 0.01,
  );
}
