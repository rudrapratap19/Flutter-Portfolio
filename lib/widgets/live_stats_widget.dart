import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/platform_stats.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';

import 'animated_counter_text.dart';

/// Compact live stats row for hero section
class LiveStatsRow extends StatefulWidget {
  const LiveStatsRow({super.key});

  @override
  State<LiveStatsRow> createState() => _LiveStatsRowState();
}

class _LiveStatsRowState extends State<LiveStatsRow> {
  AllStats? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    ApiService.fetchAllStats().then((s) {
      if (mounted) setState(() { _stats = s; _loading = false; });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lc = _stats?.leetcode ?? LeetCodeStats.fallback;
    final gh = _stats?.github ?? GitHubStats.fallback;
    final isDesktop = MediaQuery.of(context).size.width > 768;

    final items = [
      _StatItem(
        targetValue: lc.totalSolved + 250,
        suffix: '+',
        label: 'Problems Solved',
        sub: 'LeetCode & GeeksforGeeks',
        color: AppColors.cyan,
        platform: 'DSA',
      ),
      _StatItem(
        targetValue: lc.contestRating.toInt(),
        suffix: '',
        label: 'Contest Rating',
        sub: 'Top ${lc.topPercentage.toStringAsFixed(1)}%',
        color: AppColors.violet,
        platform: 'LeetCode',
      ),
      _StatItem(
        targetValue: gh.publicRepos,
        suffix: '',
        label: 'GitHub Repos',
        sub: '${gh.totalStars} ⭐ stars',
        color: AppColors.purple,
        platform: 'GitHub',
      ),
      _StatItem(
        targetValue: 2,
        suffix: '+',
        label: 'Internships',
        sub: 'Flutter • Full Stack',
        color: AppColors.indigo,
        platform: 'Work',
      ),
    ];

    if (_loading) {
      return Wrap(
        alignment: WrapAlignment.center,
        spacing: 12,
        runSpacing: 12,
        children: List.generate(4, (i) => _ShimmerCard(isDesktop: isDesktop)),
      ).animate().fadeIn(delay: 900.ms, duration: 400.ms);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: items.asMap().entries.map((e) {
        return _LiveCard(item: e.value, delay: e.key * 100, isDesktop: isDesktop);
      }).toList(),
    ).animate().fadeIn(delay: 900.ms, duration: 600.ms);
  }
}

class _StatItem {
  final int targetValue;
  final String suffix, label, sub, platform;
  final Color color;
  const _StatItem({
    required this.targetValue,
    required this.suffix,
    required this.label,
    required this.sub,
    required this.color,
    required this.platform,
  });
}

class _LiveCard extends StatefulWidget {
  final _StatItem item;
  final int delay;
  final bool isDesktop;
  const _LiveCard({required this.item, required this.delay, required this.isDesktop});
  @override
  State<_LiveCard> createState() => _LiveCardState();
}

class _LiveCardState extends State<_LiveCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.item;

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        final cardBg = isDark
            ? (_hovered ? c.color.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.03))
            : (_hovered ? c.color.withValues(alpha: 0.06) : Colors.white);

        final borderColor = isDark
            ? (_hovered ? c.color.withValues(alpha: 0.45) : Colors.white.withValues(alpha: 0.07))
            : (_hovered ? c.color.withValues(alpha: 0.5) : AppColors.lightBorder);

        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: widget.isDesktop ? 160 : 140,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: _hovered ? 0.08 : 0.04),
                        blurRadius: _hovered ? 12 : 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      c.platform,
                      style: GoogleFonts.inter(
                        color: c.color,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const Spacer(),
                    _PulseDot(color: c.color),
                  ],
                ),
                const SizedBox(height: 8),
                AnimatedCounterText(
                  targetValue: c.targetValue,
                  suffix: c.suffix,
                  style: GoogleFonts.spaceGrotesk(
                    color: c.color,
                    fontSize: widget.isDesktop ? 24 : 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  c.label,
                  style: GoogleFonts.inter(
                    color: AppColors.getTextSecondary(isDark),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  c.sub,
                  style: GoogleFonts.inter(
                    color: AppColors.getTextMuted(isDark),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: widget.delay), duration: 500.ms).slideY(begin: 0.2);
      },
    );
  }
}

class _PulseDot extends StatefulWidget {
  final Color color;
  const _PulseDot({required this.color});
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF22C55E).withValues(alpha: _anim.value),
        ),
      ),
    );
  }
}

class _ShimmerCard extends StatefulWidget {
  final bool isDesktop;
  const _ShimmerCard({required this.isDesktop});
  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.03, end: 0.08).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.isDesktop ? 160 : 140,
        height: 88,  // Fixed height to avoid overflow
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          color: Colors.white.withValues(alpha: _anim.value),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _shimmerBar(50, 8),
            const SizedBox(height: 10),
            _shimmerBar(36, 18),
            const SizedBox(height: 6),
            _shimmerBar(80, 8),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBar(double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(3),
    ),
  );
}
