import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core background and surface
  static const Color background = Color(0xFF060E20);
  static const Color surface = Color(0xFF060E20);
  
  // Containers with different elevations (Tonal Depth)
  static const Color surfaceContainerLowest = Color(0xFF000000);
  static const Color surfaceContainerLow = Color(0xFF091328);
  static const Color surfaceContainer = Color(0xFF0F1930);
  static const Color surfaceContainerHigh = Color(0xFF141F38);
  static const Color surfaceContainerHighest = Color(0xFF192540);
  static const Color surfaceVariant = Color(0xFF192540);

  // Primary brand colors (Gradient points)
  static const Color primary = Color(0xFFB6A0FF);
  static const Color primaryDim = Color(0xFF7E51FF);
  static const Color primaryContainer = Color(0xFFA98FFF);
  static const Color onPrimary = Color(0xFF340090);
  static const Color onPrimaryContainer = Color(0xFF280072);

  // Secondary brand colors (income, growth trends)
  static const Color secondary = Color(0xFF68FADD);
  static const Color secondaryDim = Color(0xFF56EBCF);
  static const Color secondaryContainer = Color(0xFF006B5C);
  static const Color onSecondary = Color(0xFF005D4F);

  // Tertiary brand colors (expenses)
  static const Color tertiary = Color(0xFFFF716C);
  static const Color tertiaryDim = Color(0xFFFF716C);
  static const Color tertiaryContainer = Color(0xFFF94D4E);
  static const Color onTertiary = Color(0xFF490006);

  // Foreground text colors
  static const Color onBackground = Color(0xFFDEE5FF);
  static const Color onSurface = Color(0xFFDEE5FF);
  static const Color onSurfaceVariant = Color(0xFFA3AAC4);

  // Error colors
  static const Color error = Color(0xFFFF6E84);
  static const Color errorContainer = Color(0xFFA70138);
  static const Color onError = Color(0xFF490013);

  // Outline/Borders (Only for fallback / accessibility, usually faint)
  static const Color outline = Color(0xFF6D758C);
  static const Color outlineVariant = Color(0xFF40485D);

  // Utility Gradients (Linear gradient from primary to primary-dim at 135 deg)
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDim],
  );
  
  // Mesh glow effect for wealth card
  static const Gradient wealthCardBackground = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color(0x1AB6A0FF), // 10% opacity primary
      Color(0x1A68FADD), // 10% opacity secondary
    ],
  );
}
