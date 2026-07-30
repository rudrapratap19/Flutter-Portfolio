import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 80 : 24,
            vertical: 80,
          ),
          child: Column(
            children: [
              _SectionHeader(title: 'About Me', subtitle: 'Who I am'),
              const SizedBox(height: 56),
              isDesktop ? _buildDesktopLayout(isDark) : _buildMobileLayout(isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildAboutText(isDark)),
        const SizedBox(width: 48),
        Expanded(flex: 3, child: _buildInfoCards()),
      ],
    );
  }

  Widget _buildMobileLayout(bool isDark) {
    return Column(
      children: [
        _buildAboutText(isDark),
        const SizedBox(height: 32),
        _buildInfoCards(),
      ],
    );
  }

  Widget _buildAboutText(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          'Hello!',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 36,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I'm a pre-final year B.Tech student in Artificial Intelligence & Data Science "
          "at IIIT Raichur. My passion lies at the intersection of cross-platform mobile "
          "development and machine learning.",
          style: GoogleFonts.inter(
            color: AppColors.getTextSecondary(isDark),
            fontSize: 16,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "I specialize in building robust Flutter applications, integrating intelligent AI models, "
          "and solving complex algorithmic problems.",
          style: GoogleFonts.inter(
            color: AppColors.getTextSecondary(isDark),
            fontSize: 16,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _Tag(label: '🚀 Flutter & Dart', color: AppColors.cyan),
            _Tag(label: '🧠 Machine Learning', color: AppColors.violet),
            _Tag(label: '⚡ Competitive Programming', color: AppColors.pink),
            _Tag(label: '🛠️ REST APIs & Firebase', color: AppColors.indigo),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 700.ms).slideX(begin: -0.1);
  }

  Widget _buildInfoCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.15,
      children: const [
        _InfoCard(
          icon: Icons.school_rounded,
          label: 'Education',
          value: 'B.Tech AI & DS',
          color: AppColors.purple,
        ),
        _InfoCard(
          icon: Icons.work_rounded,
          label: 'Experience',
          value: '2+ Internships',
          color: AppColors.cyan,
        ),
        _InfoCard(
          icon: Icons.code_rounded,
          label: 'LeetCode',
          value: '1450+ Rating',
          color: AppColors.violet,
        ),
        _InfoCard(
          icon: Icons.emoji_events_rounded,
          label: 'GATE CS',
          value: '2026 Qualified',
          color: AppColors.indigo,
        ),
      ],
    ).animate().fadeIn(delay: 200.ms, duration: 700.ms).slideX(begin: 0.1);
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return GlassCard(
          padding: const EdgeInsets.all(20),
          glowColor: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.getTextPrimary(isDark),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppColors.getTextMuted(isDark),
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          subtitle.toUpperCase(),
          style: GoogleFonts.inter(
            color: AppColors.violet,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.purple, AppColors.cyan],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

