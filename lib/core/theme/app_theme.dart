import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      
      // Text theme using Manrope for Display/Heads, Inter for Body/Labels
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 57,
        ),
        displayMedium: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 45,
        ),
        displaySmall: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
        headlineLarge: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 32,
        ),
        headlineMedium: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 28,
        ),
        headlineSmall: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        titleLarge: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 22,
        ),
        titleMedium: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        titleSmall: GoogleFonts.manrope(
          color: AppColors.secondary, // Secondary color for positive growth trend
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant,
          fontSize: 12,
        ),
        labelLarge: GoogleFonts.inter(
          color: AppColors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: GoogleFonts.inter(
          color: AppColors.onSurfaceVariant,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Elevated Button Style - Gradient Button implementation
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent, // Background handled by container gradient
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // round_full
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),

      // Input Decoration Theme - Glassmorphism fallback
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerHighest,
        hintStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.outlineVariant, width: 0.5), // ghost border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.15), width: 0.5), // 15% opacity
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.6), width: 1.5), // focus edge
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          color: AppColors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
      
      // Dialog / Modal theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerHighest.withValues(alpha: 0.8),
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}
