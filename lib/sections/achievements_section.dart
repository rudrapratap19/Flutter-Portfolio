import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  static const _achievements = [
    (
      icon: Icons.military_tech_rounded,
      title: 'GATE CS 2026',
      desc: 'Qualified Graduate Aptitude Test in Engineering for Computer Science',
      color: AppColors.violet,
    ),
    (
      icon: Icons.leaderboard_rounded,
      title: 'LeetCode Top 5000',
      desc: 'Secured under 5000 global rank in LeetCode Biweekly Contest with 1450+ rating',
      color: AppColors.cyan,
    ),
    (
      icon: Icons.code_rounded,
      title: '474+ DSA Problems',
      desc: 'Solved 474+ problems combined across LeetCode (224+) and GeeksforGeeks (250+)',
      color: AppColors.indigo,
    ),
    (
      icon: Icons.groups_rounded,
      title: 'Academic Secretary',
      desc: 'Led student initiatives impacting 600+ students; revived Aurora Club with 70%+ participation',
      color: AppColors.purple,
    ),
    (
      icon: Icons.business_center_rounded,
      title: 'Placement Cell Coordinator',
      desc: 'Coordinated with 15+ recruiters, improved response efficiency by 25% through structured workflows',
      color: AppColors.pink,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 80,
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 56),
          isDesktop ? _buildDesktopGrid() : _buildMobileList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'HIGHLIGHTS',
          style: GoogleFonts.inter(
            color: AppColors.pink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          'Achievements',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
          gradient: const LinearGradient(
            colors: [AppColors.pink, AppColors.violet],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.pink, AppColors.violet],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopGrid() {
    // 3-2 layout
    return Column(
      children: [
        Row(
          children: _achievements.take(3).toList().asMap().entries.map((e) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: e.key < 2 ? 20 : 0),
                child: _AchievementCard(item: e.value, delay: e.key * 100),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            ..._achievements.skip(3).toList().asMap().entries.map((e) {
              return Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: e.key == 0 ? 0 : 20,
                    right: e.key == 0 ? 20 : 0,
                  ),
                  child: _AchievementCard(
                    item: e.value,
                    delay: (e.key + 3) * 100,
                  ),
                ),
              );
            }),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: _achievements.asMap().entries.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _AchievementCard(item: e.value, delay: e.key * 100),
        );
      }).toList(),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final ({
    IconData icon,
    String title,
    String desc,
    Color color,
  }) item;
  final int delay;

  const _AchievementCard({required this.item, required this.delay});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return GlassCard(
          glowColor: item.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                item.title,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.getTextPrimary(isDark),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.desc,
                style: GoogleFonts.inter(
                  color: AppColors.getTextSecondary(isDark),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],
          ),
        );
      },
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
        .slideY(begin: 0.15);
  }
}
