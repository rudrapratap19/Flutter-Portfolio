import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme_notifier.dart';
import '../theme/app_colors.dart';

class ThemeModeToggle extends StatelessWidget {
  const ThemeModeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, currentMode, child) {
        final isDark = currentMode == AppThemeMode.dark;

        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0F172A).withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : AppColors.lightBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(
                context: context,
                mode: AppThemeMode.light,
                activeMode: currentMode,
                icon: Icons.wb_sunny_rounded,
                label: 'Light',
                activeColor: const Color(0xFFEAB308), // Warm Amber
                isDark: isDark,
              ),
              _buildOption(
                context: context,
                mode: AppThemeMode.dark,
                activeMode: currentMode,
                icon: Icons.nightlight_round,
                label: 'Dark',
                activeColor: const Color(0xFF8B5CF6), // Violet
                isDark: isDark,
              ),
              _buildOption(
                context: context,
                mode: AppThemeMode.cmd,
                activeMode: currentMode,
                icon: Icons.terminal_rounded,
                label: 'CMD',
                activeColor: const Color(0xFF00FF66), // Neon Terminal Green
                isDark: isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required AppThemeMode mode,
    required AppThemeMode activeMode,
    required IconData icon,
    required String label,
    required Color activeColor,
    required bool isDark,
  }) {
    final isActive = mode == activeMode;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          ThemeNotifier.instance.setTheme(mode);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withValues(alpha: isDark ? 0.25 : 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: isActive
                ? Border.all(color: activeColor.withValues(alpha: 0.5), width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 15,
                color: isActive
                    ? activeColor
                    : (isDark ? Colors.white60 : Colors.black54),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? activeColor
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
