import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.purple,
        secondary: AppColors.cyan,
        surface: AppColors.surface,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 72,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 56,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 16,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.textSecondary,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.indigo,
        secondary: AppColors.cyan,
        surface: AppColors.lightSurface,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.lightTextPrimary,
          fontSize: 72,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.lightTextPrimary,
          fontSize: 56,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
        ),
        displaySmall: GoogleFonts.spaceGrotesk(
          color: AppColors.lightTextPrimary,
          fontSize: 40,
          fontWeight: FontWeight.w700,
          letterSpacing: -1,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          color: AppColors.lightTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          color: AppColors.lightTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: AppColors.lightTextSecondary,
          fontSize: 16,
          height: 1.7,
        ),
        bodyMedium: GoogleFonts.inter(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }
}
