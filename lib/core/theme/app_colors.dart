import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core background and surface
  static const Color background = Color(0xFF030712); // Deep midnight black
  static const Color surface = Color(0xFF0F172A); // Slate surface
  
  // Containers with different elevations (Tonal Depth)
  static const Color surfaceContainerLowest = Color(0xFF020617);
  static const Color surfaceContainerLow = Color(0xFF0F172A);
  static const Color surfaceContainer = Color(0xFF1E293B);
  static const Color surfaceContainerHigh = Color(0xFF334155);
  static const Color surfaceContainerHighest = Color(0xFF475569);
  static const Color surfaceVariant = Color(0xFF1E293B);

  // Primary brand colors (Vibrant Indigo / Violet)
  static const Color primary = Color(0xFF818CF8); // Indigo-400
  static const Color primaryDim = Color(0xFF6366F1); // Indigo-500
  static const Color primaryContainer = Color(0xFF4F46E5); // Indigo-600
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFFE0E7FF);

  // Secondary brand colors (Emerald for positive growth)
  static const Color secondary = Color(0xFF34D399); // Emerald-400
  static const Color secondaryDim = Color(0xFF10B981); // Emerald-500
  static const Color secondaryContainer = Color(0xFF065F46);
  static const Color onSecondary = Colors.white;

  // Tertiary brand colors (Rose for negative trends)
  static const Color tertiary = Color(0xFFFB7185); // Rose-400
  static const Color tertiaryDim = Color(0xFFF43F5E); // Rose-500
  static const Color tertiaryContainer = Color(0xFF9F1239);
  static const Color onTertiary = Colors.white;

  // Foreground text colors
  static const Color onBackground = Color(0xFFF8FAFC);
  static const Color onSurface = Color(0xFFF8FAFC);
  static const Color onSurfaceVariant = Color(0xFF94A3B8);

  // Error colors
  static const Color error = Color(0xFFEF4444);
  static const Color errorContainer = Color(0xFF7F1D1D);
  static const Color onError = Colors.white;

  // Outline/Borders
  static const Color outline = Color(0xFF334155);
  static const Color outlineVariant = Color(0xFF1E293B);

  // Premium Mesh Gradient Tokens
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDim],
  );
  
  // Mesh effect: Layered gradients to create that "alive" feeling
  static const List<Gradient> wealthCardMesh = [
    RadialGradient(
      center: Alignment(-0.8, -0.6),
      radius: 1.2,
      colors: [Color(0x33818CF8), Colors.transparent], // 20% opacity primary
    ),
    RadialGradient(
      center: Alignment(0.8, 0.6),
      radius: 1.0,
      colors: [Color(0x3334D399), Colors.transparent], // 20% opacity secondary
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    ),
  ];

  static const Gradient glassBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x1FFFFFFF), // 12% white
      Color(0x0AFFFFFF), // 4% white
    ],
  );
}
