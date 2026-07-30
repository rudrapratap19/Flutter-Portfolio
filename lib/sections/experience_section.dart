import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  static const _experiences = [
    (
      role: 'Junior Flutter Developer',
      company: 'Webintegratorz Technologies',
      period: 'May 2026 – Present',
      color: AppColors.violet,
      points: [
        'Developed scalable Flutter features with reusable UI components, REST API integrations, and async workflows.',
        'Implemented state management and debugging solutions to improve application responsiveness and maintainability.',
        'Collaborated with backend developers and designers in agile workflows to ship production-ready mobile features.',
      ],
    ),
    (
      role: 'Flutter Developer Intern',
      company: 'Syflex Techno Solution Pvt. Ltd.',
      period: 'Mar 2026 – May 2026',
      color: AppColors.cyan,
      points: [
        'Integrated REST APIs and Firebase services for structured and reliable data flow across application modules.',
        'Implemented async state management, validation, and error handling to improve app stability.',
        'Worked on real-time synchronization and backend integration for mobile application workflows.',
      ],
    ),
  ];

  static const _leadership = [
    (
      role: 'Placement Coordinator',
      company: 'Student Leadership',
      period: 'Jan 2026 – May 2026',
      color: AppColors.pink,
      points: [
        'Spearheaded placement drives and fostered corporate relations, leading to increased recruitment opportunities.',
        'Organized mock interviews, resume reviews, and skill-building workshops for graduating students.',
      ],
    ),
    (
      role: 'Teaching Assistant',
      company: 'Student Leadership',
      period: 'Aug 2025 – Dec 2025',
      color: AppColors.purple,
      points: [
        'Assisted professors in evaluating assignments and conducting tutorial sessions for undergraduate courses.',
        'Mentored students in foundational AI concepts and guided them through programming assignments.',
      ],
    ),
    (
      role: 'Internship Coordinator',
      company: 'Student Leadership',
      period: 'Aug 2025 – Dec 2025',
      color: AppColors.indigo,
      points: [
        'Facilitated internship processes by connecting students with tech startups and established IT firms.',
        'Streamlined the application tracking system for students securing off-campus and on-campus internships.',
      ],
    ),
    (
      role: 'Academic Secretary',
      company: 'Student Leadership',
      period: 'Aug 2024 – Aug 2025',
      color: AppColors.cyan,
      points: [
        'Served as the primary liaison between the student body and faculty regarding academic curriculum and policies.',
        'Successfully advocated for student academic needs and organized student-faculty feedback sessions.',
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
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                // ── Year Milestone 2026 ──
                _YearMilestone(year: '2026', color: AppColors.violet, delay: 0),
                const SizedBox(height: 16),

                ..._experiences.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _ExperienceCard(
                      experience: entry.value,
                      delay: entry.key * 150,
                      isFirst: entry.key == 0,
                    ),
                  );
                }),
                
                const SizedBox(height: 16),
                // ── Year Milestone 2025 ──
                _YearMilestone(year: '2025', color: AppColors.cyan, delay: 200),
                const SizedBox(height: 24),
                
                // Leadership Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.glassBorder,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'LEADERSHIP & INITIATIVES',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppColors.glassBorder,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 400.ms),
                
                const SizedBox(height: 32),
                
                ..._leadership.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: _ExperienceCard(
                      experience: entry.value,
                      delay: 400 + (entry.key * 150),
                      isFirst: false,
                      isLeadership: true,
                    ),
                  );
                }),

                const SizedBox(height: 16),
                // ── Year Milestone 2023 – The Origin ──
                _YearMilestone(year: '2023', color: AppColors.indigo, delay: 600,
                  label: 'Started B.Tech @ IIIT Raichur'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'MY JOURNEY',
          style: GoogleFonts.inter(
            color: AppColors.violet,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          'Experience',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
          gradient: const LinearGradient(
            colors: [AppColors.violet, AppColors.cyan],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.violet, AppColors.cyan],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _YearMilestone extends StatefulWidget {
  final String year;
  final Color color;
  final int delay;
  final String? label;

  const _YearMilestone({
    required this.year,
    required this.color,
    required this.delay,
    this.label,
  });

  @override
  State<_YearMilestone> createState() => _YearMilestoneState();
}

class _YearMilestoneState extends State<_YearMilestone>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;
        return Row(
          children: [
            // Glow node
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) => Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.12),
                  border: Border.all(color: widget.color, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: _pulseAnim.value * 0.4),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color,
                      boxShadow: [
                        BoxShadow(
                          color: widget.color.withValues(alpha: _pulseAnim.value * 0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Year label
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.year,
                    style: GoogleFonts.spaceGrotesk(
                      color: widget.color,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  if (widget.label != null)
                    Text(
                      widget.label!,
                      style: GoogleFonts.inter(
                        color: AppColors.getTextMuted(isDark),
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Horizontal line extending to right
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 600.ms)
            .slideX(begin: -0.1, curve: Curves.easeOut);
      },
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final ({
    String role,
    String company,
    String period,
    Color color,
    List<String> points,
  }) experience;
  final int delay;
  final bool isFirst;
  final bool isLeadership;

  const _ExperienceCard({
    required this.experience,
    required this.delay,
    required this.isFirst,
    this.isLeadership = false,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _isHovered = false;
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    // If it's hovered (on desktop) or expanded (via tap on mobile), show details
    final showDetails = _isHovered || _isExpanded;

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline
            Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [widget.experience.color, AppColors.purple],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.experience.color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 2,
                  height: showDetails
                      ? (widget.experience.points.length * 50.0 + 80)
                      : 100, // Dynamic line height
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        widget.experience.color.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            // Interactive Card
            Expanded(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _toggleExpanded,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    transform: showDetails
                        ? (Matrix4.identity()..translate(0.0, -4.0))
                        : Matrix4.identity(),
                    child: GlassCard(
                      glowColor: widget.experience.color,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              if (widget.isFirst)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.experience.color.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: widget.experience.color.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '🔥 Current',
                                    style: GoogleFonts.inter(
                                      color: widget.experience.color,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              if (widget.isFirst) const SizedBox(width: 10),
                              if (widget.isLeadership)
                                Icon(
                                  Icons.groups_rounded,
                                  color: widget.experience.color,
                                  size: 16,
                                ),
                              const Spacer(),
                              Flexible(
                                child: Text(
                                  widget.experience.period,
                                  style: GoogleFonts.inter(
                                    color: AppColors.getTextMuted(isDark),
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            widget.experience.role,
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.getTextPrimary(isDark),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.experience.company,
                            style: GoogleFonts.inter(
                              color: widget.experience.color,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          
                          // Animated Expansion for Bullet Points
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: showDetails
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 16),
                                      ...widget.experience.points.map((point) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 8),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(top: 7),
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: widget.experience.color,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  point,
                                                  style: GoogleFonts.inter(
                                                    color: AppColors.getTextSecondary(isDark),
                                                    fontSize: 13,
                                                    height: 1.7,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 700.ms)
        .slideX(begin: -0.1);
  }
}
