import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/gradient_text.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  static const _skillGroups = [
    (
      label: 'Mobile & Frontend',
      icon: Icons.phone_android_rounded,
      color: AppColors.purple,
      skills: [
        'Flutter',
        'Dart',
        'Firebase',
        'Supabase',
        'BLoC',
        'Provider',
        'REST APIs',
        'JavaScript',
      ],
    ),
    (
      label: 'Backend',
      icon: Icons.dns_rounded,
      color: AppColors.cyan,
      skills: [
        'Node.js',
        'Express.js',
        'Prisma ORM',
        'JWT Auth',
        'MVC Architecture',
        'REST APIs',
      ],
    ),
    (
      label: 'Databases',
      icon: Icons.storage_rounded,
      color: AppColors.indigo,
      skills: [
        'PostgreSQL',
        'SQL',
        'Firestore',
        'Supabase',
      ],
    ),
    (
      label: 'AI & Machine Learning',
      icon: Icons.psychology_rounded,
      color: AppColors.violet,
      skills: [
        'Python',
        'Deep Learning',
        'Transformers',
        'NLP',
        'Machine Learning',
        'Pandas',
        'SciPy',
        'Matplotlib',
      ],
    ),
    (
      label: 'Languages',
      icon: Icons.code_rounded,
      color: AppColors.pink,
      skills: [
        'Dart',
        'Python',
        'JavaScript',
        'C',
        'C++',
        'SQL',
      ],
    ),
    (
      label: 'Tools & Platforms',
      icon: Icons.build_rounded,
      color: AppColors.cyan,
      skills: [
        'Git',
        'GitHub',
        'Postman',
        'VS Code',
        'Android Studio',
      ],
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
          'WHAT I WORK WITH',
          style: GoogleFonts.inter(
            color: AppColors.cyan,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          'Technical Skills',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
          gradient: const LinearGradient(
            colors: [AppColors.cyan, AppColors.violet],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.cyan, AppColors.violet],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 40) / 3;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: _skillGroups.asMap().entries.map((entry) {
            return SizedBox(
              width: itemWidth,
              child: _SkillGroupCard(group: entry.value, delay: entry.key * 100),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: _skillGroups.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _SkillGroupCard(group: entry.value, delay: entry.key * 100),
        );
      }).toList(),
    );
  }
}

class _SkillGroupCard extends StatefulWidget {
  final ({
    String label,
    IconData icon,
    Color color,
    List<String> skills,
  }) group;
  final int delay;

  const _SkillGroupCard({required this.group, required this.delay});

  @override
  State<_SkillGroupCard> createState() => _SkillGroupCardState();
}

class _SkillGroupCardState extends State<_SkillGroupCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        final cardBg = isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white;
        final borderColor = _isHovered
            ? widget.group.color.withValues(alpha: isDark ? 0.35 : 0.5)
            : AppColors.getCardBorder(isDark);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            transform: _isHovered
                ? (Matrix4.identity()..translate(0.0, -4.0))
                : Matrix4.identity(),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.04),
                        widget.group.color.withValues(alpha: 0.02),
                      ],
                    )
                  : null,
              boxShadow: isDark
                  ? (_isHovered
                      ? [
                          BoxShadow(
                            color: widget.group.color.withValues(alpha: 0.15),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ]
                      : [])
                  : [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.08 : 0.04),
                        blurRadius: _isHovered ? 16 : 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: widget.group.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.group.icon, color: widget.group.color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        widget.group.label,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.getTextPrimary(isDark),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.group.skills.map((skill) {
                    return _SkillChip(
                      skill: skill,
                      color: widget.group.color,
                      isDark: isDark,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 600.ms)
        .slideY(begin: 0.2);
  }
}

class _SkillChip extends StatefulWidget {
  final String skill;
  final Color color;
  final bool isDark;

  const _SkillChip({
    required this.skill,
    required this.color,
    this.isDark = true,
  });

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _isHovered
              ? widget.color.withValues(alpha: 0.2)
              : widget.color.withValues(alpha: widget.isDark ? 0.08 : 0.12),
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: widget.color.withValues(alpha: _isHovered ? 0.6 : 0.25),
          ),
        ),
        child: Text(
          widget.skill,
          style: GoogleFonts.inter(
            color: _isHovered ? widget.color : AppColors.getTextSecondary(widget.isDark),
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
