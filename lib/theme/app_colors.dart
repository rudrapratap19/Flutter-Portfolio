import 'package:flutter/material.dart';

class AppColors {
  // Dark Backgrounds
  static const Color background = Color(0xFF0B1020);
  static const Color backgroundSecondary = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);

  // Light Backgrounds
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Accents
  static const Color purple = Color(0xFF7C3AED);
  static const Color violet = Color(0xFFA855F7);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color indigo = Color(0xFF6366F1);
  static const Color pink = Color(0xFFEC4899);

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Light Text
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [purple, violet, cyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFA855F7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dynamic Color Helpers
  static Color getBackground(bool isDark) => isDark ? background : lightBackground;
  static Color getSidebarBg(bool isDark) => isDark ? const Color(0xFF070B14) : lightSurface;
  static Color getCardBg(bool isDark) => isDark ? const Color(0x0DFFFFFF) : lightSurface;
  static Color getCardBorder(bool isDark) => isDark ? const Color(0x1AFFFFFF) : lightBorder;
  static Color getTextPrimary(bool isDark) => isDark ? textPrimary : lightTextPrimary;
  static Color getTextSecondary(bool isDark) => isDark ? textSecondary : lightTextSecondary;
  static Color getTextMuted(bool isDark) => isDark ? textMuted : lightTextMuted;

  // Glass & Glow
  static const Color glassBackground = Color(0x0DFFFFFF);
  static const Color glassBorder = Color(0x1AFFFFFF);
  static Color purpleGlow = const Color(0xFF7C3AED).withValues(alpha: 0.3);
  static Color cyanGlow = const Color(0xFF06B6D4).withValues(alpha: 0.3);
  static Color violetGlow = const Color(0xFFA855F7).withValues(alpha: 0.2);
}
