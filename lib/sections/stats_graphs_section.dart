import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/platform_stats.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/animated_counter_text.dart';
import '../widgets/scroll_trigger_animator.dart';
import '../widgets/reveal_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class StatsGraphsSection extends StatefulWidget {
  const StatsGraphsSection({super.key});

  @override
  State<StatsGraphsSection> createState() => _StatsGraphsSectionState();
}

class _StatsGraphsSectionState extends State<StatsGraphsSection> {
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
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final lc = _stats?.leetcode ?? LeetCodeStats.fallback;
    final gh = _stats?.github ?? GitHubStats.fallback;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 64,
      ),
      child: Column(
        children: [
          // ── Header ──
          RevealWidget(
            child: Column(
              children: [
                Text('LIVE STATS',
                    style: GoogleFonts.inter(
                      color: AppColors.cyan,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    )),
                const SizedBox(height: 8),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (b) => const LinearGradient(
                    colors: [AppColors.cyan, AppColors.violet],
                  ).createShader(b),
                  child: Text(
                    'Coding Activity',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // ── Combined Stats Banner ──
          RevealWidget(
            child: _CombinedStatsBanner(
              leetCodeSolved: lc.totalSolved,
              gfgSolved: 250,
              loading: _loading,
            ),
          ),

          const SizedBox(height: 40),

          // ── Charts Grid ──
          if (isDesktop)
            Column(
              children: [
                // Row 1: LeetCode Donut + LeetCode Rating Line
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: RevealWidget(
                        delay: const Duration(milliseconds: 0),
                        child: _LeetCodeDonutCard(lc: lc, loading: _loading),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 2,
                      child: RevealWidget(
                        delay: const Duration(milliseconds: 120),
                        child: _LeetCodeRatingCard(lc: lc, loading: _loading),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Row 2: GitHub Repos Bar + GFG Score
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: RevealWidget(
                        delay: const Duration(milliseconds: 200),
                        child: _GitHubRealActivityCard(gh: gh, loading: _loading),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: RevealWidget(
                        delay: const Duration(milliseconds: 300),
                        child: const _GFGScoreCard(),
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            Column(
              children: [
                RevealWidget(child: _LeetCodeDonutCard(lc: lc, loading: _loading)),
                const SizedBox(height: 16),
                RevealWidget(
                    delay: const Duration(milliseconds: 100),
                    child: _LeetCodeRatingCard(lc: lc, loading: _loading)),
                const SizedBox(height: 16),
                RevealWidget(
                    delay: const Duration(milliseconds: 200),
                    child: _GitHubRealActivityCard(gh: gh, loading: _loading)),
                const SizedBox(height: 16),
                RevealWidget(
                    delay: const Duration(milliseconds: 300),
                    child: const _GFGScoreCard()),
              ],
            ),
        ],
      ),
    );
  }
}

// ─── Combined Stats Banner ───────────────────────────────────────────────────

class _CombinedStatsBanner extends StatelessWidget {
  final int leetCodeSolved;
  final int gfgSolved;
  final bool loading;

  const _CombinedStatsBanner({
    required this.leetCodeSolved,
    required this.gfgSolved,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final totalCombined = leetCodeSolved + gfgSolved;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.violet.withValues(alpha: 0.3)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.violet.withValues(alpha: 0.12),
            AppColors.cyan.withValues(alpha: 0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.violet.withValues(alpha: 0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              children: [
                _buildTotalCounter(totalCombined),
                const SizedBox(width: 32),
                Container(
                  width: 1,
                  height: 60,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                const SizedBox(width: 32),
                Expanded(child: _buildBreakdownBar(leetCodeSolved, gfgSolved)),
              ],
            )
          : Column(
              children: [
                _buildTotalCounter(totalCombined),
                const SizedBox(height: 20),
                _buildBreakdownBar(leetCodeSolved, gfgSolved),
              ],
            ),
    );
  }

  Widget _buildTotalCounter(int totalCombined) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.violet.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.violet,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedCounterText(
                targetValue: totalCombined,
                suffix: '+',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total Problems Solved Across Platforms',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownBar(int lcSolved, int gfgSolved) {
    final total = (lcSolved + gfgSolved).clamp(1, 10000);
    final lcRatio = lcSolved / total;
    final gfgRatio = gfgSolved / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: 12,
          children: [
            _PlatformPill(
              label: 'LeetCode',
              count: lcSolved,
              color: AppColors.cyan,
              icon: Icons.code_rounded,
            ),
            const SizedBox(width: 12),
            _PlatformPill(
              label: 'GeeksforGeeks',
              count: gfgSolved,
              color: const Color(0xFF2F8D46),
              icon: Icons.functions_rounded,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 10,
            child: Row(
              children: [
                Expanded(
                  flex: (lcRatio * 100).toInt(),
                  child: Container(color: AppColors.cyan),
                ),
                const SizedBox(width: 2),
                Expanded(
                  flex: (gfgRatio * 100).toInt(),
                  child: Container(color: const Color(0xFF2F8D46)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlatformPill extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _PlatformPill({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12),
        ),
        AnimatedCounterText(
          targetValue: count,
          suffix: '+',
          style: GoogleFonts.spaceGrotesk(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ─── Chart Cards ──────────────────────────────────────────────────────────────

class _GraphCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color accentColor;
  final Widget chart;
  final double height;
  final String? linkUrl;

  const _GraphCard({
    required this.title,
    required this.subtitle,
    required this.accentColor,
    required this.chart,
    this.height = 220,
    this.linkUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.getCardBorder(isDark),
            ),
            color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 18,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.getTextPrimary(isDark),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: GoogleFonts.inter(
                            color: AppColors.getTextMuted(isDark),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (linkUrl != null)
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.open_in_new, size: 18),
                        color: AppColors.getTextMuted(isDark),
                        onPressed: () => launchUrl(Uri.parse(linkUrl!)),
                        tooltip: 'View Profile',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(height: height, child: chart),
            ],
          ),
        );
      },
    );
  }
}

// ─── LeetCode Donut ──────────────────────────────────────────────────────────

class _LeetCodeDonutCard extends StatefulWidget {
  final LeetCodeStats lc;
  final bool loading;
  const _LeetCodeDonutCard({required this.lc, required this.loading});
  @override
  State<_LeetCodeDonutCard> createState() => _LeetCodeDonutCardState();
}

class _LeetCodeDonutCardState extends State<_LeetCodeDonutCard> {
  int _touch = -1;

  @override
  Widget build(BuildContext context) {
    final lc = widget.lc;

    return _GraphCard(
      title: 'Problems Solved',
      subtitle: 'LeetCode • ${lc.totalSolved} total',
      accentColor: AppColors.cyan,
      height: 210,
      linkUrl: 'https://leetcode.com/u/rpsinghiiitr/',
      chart: widget.loading
          ? _buildLoadingIndicator()
          : ScrollTriggerAnimator(
              builder: (context, anim, _) {
                return Row(
                  children: [
                    Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              _touch = -1;
                              return;
                            }
                            _touch = response
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sections: [
                        _pie(
                            lc.easySolved.toDouble() * anim == 0 ? 0.001 : lc.easySolved.toDouble() * anim,
                            const Color(0xFF22C55E),
                            'Easy',
                            0),
                        _pie(
                            lc.mediumSolved.toDouble() * anim == 0 ? 0.001 : lc.mediumSolved.toDouble() * anim,
                            const Color(0xFFF59E0B),
                            'Med',
                            1),
                        _pie(
                            lc.hardSolved.toDouble() * anim == 0 ? 0.001 : lc.hardSolved.toDouble() * anim,
                            const Color(0xFFEF4444),
                            'Hard',
                            2),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Legend(
                          color: const Color(0xFF22C55E),
                          label: 'Easy',
                          count: lc.easySolved),
                      const SizedBox(height: 10),
                      _Legend(
                          color: const Color(0xFFF59E0B),
                          label: 'Medium',
                          count: lc.mediumSolved),
                      const SizedBox(height: 10),
                      _Legend(
                          color: const Color(0xFFEF4444),
                          label: 'Hard',
                          count: lc.hardSolved),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
    );
  }

  PieChartSectionData _pie(
      double value, Color color, String label, int index) {
    final isTouched = index == _touch;
    return PieChartSectionData(
      value: value,
      color: color,
      radius: isTouched ? 52 : 44,
      titleStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: isTouched ? 13 : 11,
        fontWeight: FontWeight.w700,
      ),
      title: value.toInt().toString(),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  const _Legend({required this.color, required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: AppColors.getTextSecondary(isDark),
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$count',
              style: GoogleFonts.spaceGrotesk(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── LeetCode Rating Line ─────────────────────────────────────────────────────

class _LeetCodeRatingCard extends StatelessWidget {
  final LeetCodeStats lc;
  final bool loading;
  const _LeetCodeRatingCard({required this.lc, required this.loading});

  @override
  Widget build(BuildContext context) {
    final rating = lc.contestRating.toStringAsFixed(0);
    return _GraphCard(
      title: 'Contest Rating',
      subtitle: 'LeetCode • Rating $rating • ${lc.contestAttend} contests',
      accentColor: AppColors.violet,
      height: 210,
      linkUrl: 'https://leetcode.com/u/rpsinghiiitr/',
      chart: loading
          ? _buildLoadingIndicator()
          : _buildLineChart(),
    );
  }

  Widget _buildLineChart() {
    final history = lc.contestHistory;
    if (history.isEmpty) return _buildLoadingIndicator();

    final spots = history.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.rating);
    }).toList();

    final minY = (history.map((c) => c.rating).reduce((a, b) => a < b ? a : b) - 50)
        .clamp(1200.0, 2000.0);
    final maxY = (history.map((c) => c.rating).reduce((a, b) => a > b ? a : b) + 50)
        .clamp(1200.0, 2000.0);

    return ScrollTriggerAnimator(
      builder: (context, anim, _) {
        final animatedSpots = spots.map((s) {
          return FlSpot(s.x, minY + (s.y - minY) * anim);
        }).toList();

        return LineChart(
      LineChartData(
        minY: minY,
        maxY: maxY,
        clipData: const FlClipData.all(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (_) => FlLine(
            color: Colors.white.withValues(alpha: 0.05),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 50,
              getTitlesWidget: (v, _) => Text(
                v.toInt().toString(),
                style: GoogleFonts.inter(
                    color: AppColors.textMuted, fontSize: 9),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i >= 0 && i < history.length) {
                  final t = history[i].title;
                  final short = t.contains('Biweekly')
                      ? 'BC${t.replaceAll(RegExp(r'[^0-9]'), '')}'
                      : 'WC${t.replaceAll(RegExp(r'[^0-9]'), '')}';
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(short,
                        style: GoogleFonts.inter(
                            color: AppColors.textMuted, fontSize: 8)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (spots) => spots.map((s) {
              return LineTooltipItem(
                s.y.toStringAsFixed(0),
                GoogleFonts.spaceGrotesk(
                    color: AppColors.violet,
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              );
            }).toList(),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: animatedSpots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.violet,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                radius: 4,
                color: AppColors.violet,
                strokeWidth: 1.5,
                strokeColor: AppColors.background,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.violet.withValues(alpha: 0.25),
                  AppColors.violet.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

// ─── Real GitHub Activity Timeline ───────────────────────────────────────────

class _GitHubRealActivityCard extends StatelessWidget {
  final GitHubStats gh;
  final bool loading;
  const _GitHubRealActivityCard({required this.gh, required this.loading});

  @override
  Widget build(BuildContext context) {
    final reposCount = gh.publicRepos > 0 ? gh.publicRepos : 22;

    return _GraphCard(
      title: 'GitHub Activity Timeline',
      subtitle: 'github.com/rudrapratap19 • $reposCount Public Repos',
      accentColor: AppColors.purple,
      height: 210,
      linkUrl: 'https://github.com/rudrapratap19',
      chart: loading ? _buildLoadingIndicator() : _buildRealActivityContent(),
    );
  }

  Widget _buildRealActivityContent() {
    // Real monthly repository pushes & project creations from GitHub API
    final monthlyActivity = [
      (month: 'Aug 25', count: 2, focus: 'ArenaFlow, Portfolio'),
      (month: 'Sep 25', count: 2, focus: 'flutter-todo, mini-store'),
      (month: 'Jan 26', count: 2, focus: 'bmi_tracker, Campus-care'),
      (month: 'Feb 26', count: 3, focus: 'Decoder-Transformer, AI'),
      (month: 'Mar 26', count: 2, focus: 'Aether, BUSI-Dataset'),
      (month: 'Apr 26', count: 3, focus: 'LLM-Discovery, CNN-LSTM'),
    ];

    final maxCount = 4.0;

    return Column(
      children: [
        // Top Real Summary Stats
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            _ActivityPill(
              label: 'Public Repos',
              value: '${gh.publicRepos > 0 ? gh.publicRepos : 22}',
              icon: Icons.folder_special_rounded,
              color: AppColors.cyan,
            ),
            _ActivityPill(
              label: 'Peak Activity',
              value: 'Feb – Apr 2026',
              icon: Icons.trending_up_rounded,
              color: AppColors.violet,
            ),
            _ActivityPill(
              label: 'Member Since',
              value: 'Nov 2024',
              icon: Icons.calendar_today_rounded,
              color: AppColors.pink,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Real Monthly Activity Bar Chart
        Expanded(
          child: ScrollTriggerAnimator(
            builder: (context, anim, _) {
              return BarChart(
            BarChartData(
              maxY: maxCount,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: Colors.white.withValues(alpha: 0.05),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    getTitlesWidget: (v, _) {
                      final i = v.toInt();
                      if (i >= 0 && i < monthlyActivity.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            monthlyActivity[i].month,
                            style: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 20,
                    interval: 1,
                    getTitlesWidget: (v, _) => Text(
                      v.toInt().toString(),
                      style: GoogleFonts.inter(
                          color: AppColors.textMuted, fontSize: 8),
                    ),
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, _, rod, __) {
                    final item = monthlyActivity[group.x];
                    return BarTooltipItem(
                      '${item.month}: ${item.count} Repos\n(${item.focus})',
                      GoogleFonts.spaceGrotesk(
                        color: AppColors.violet,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                    );
                  },
                ),
              ),
              barGroups: monthlyActivity.asMap().entries.map((e) {
                final count = e.value.count.toDouble();
                return BarChartGroupData(
                  x: e.key,
                  barRods: [
                    BarChartRodData(
                      toY: count * anim,
                      width: 18,
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.violet.withValues(alpha: 0.4),
                          AppColors.cyan.withValues(alpha: 0.9),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ActivityPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ActivityPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.1 : 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 13),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.getTextPrimary(isDark),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: AppColors.getTextMuted(isDark),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── GFG Score Gauge ─────────────────────────────────────────────────────────

class _GFGScoreCard extends StatelessWidget {
  const _GFGScoreCard();

  static const _gfgScore = 450;
  static const _maxScore = 600;
  static const _solvedBasic = 40;
  static const _solvedEasy = 120;
  static const _solvedMedium = 80;
  static const _solvedHard = 10;

  @override
  Widget build(BuildContext context) {
    return _GraphCard(
      title: 'GeeksforGeeks',
      subtitle: 'Score $_gfgScore+ • rpsinghlfb9',
      accentColor: const Color(0xFF2F8D46),
      height: 210,
      linkUrl: 'https://www.geeksforgeeks.org/user/rpsinghlfb9/',
      chart: ScrollTriggerAnimator(
        builder: (context, anim, _) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Score ring
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: anim * (_gfgScore / _maxScore),
                    strokeWidth: 10,
                    backgroundColor: Colors.white.withValues(alpha: 0.07),
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF2F8D46)),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(anim * _gfgScore).toInt()}+',
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFF2F8D46),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('Score',
                        style: GoogleFonts.inter(
                            color: AppColors.textMuted, fontSize: 11)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Difficulty breakdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _GFGMini(label: 'Basic', count: (_solvedBasic * anim).toInt(), color: const Color(0xFF94A3B8)),
                _GFGMini(label: 'Easy', count: (_solvedEasy * anim).toInt(), color: const Color(0xFF22C55E)),
                _GFGMini(label: 'Med', count: (_solvedMedium * anim).toInt(), color: const Color(0xFFF59E0B)),
                _GFGMini(label: 'Hard', count: (_solvedHard * anim).toInt(), color: const Color(0xFFEF4444)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GFGMini extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _GFGMini({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Column(
          children: [
            Text('$count',
                style: GoogleFonts.spaceGrotesk(
                    color: color, fontSize: 14, fontWeight: FontWeight.w700)),
            Text(label,
                style: GoogleFonts.inter(
                    color: AppColors.getTextMuted(isDark), fontSize: 10)),
          ],
        );
      },
    );
  }
}

// ─── Shared Loading Indicator ─────────────────────────────────────────────────

Widget _buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: AppColors.violet,
    ),
  );
}
