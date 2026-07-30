import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  static final _projects = [
    _Project(
      title: 'Modern Retrieval-Augmented Discovery\nof RESTful Web APIs',
      subtitle: '📄 Research Paper – Under Review',
      tags: ['Python', 'NLP', 'LLMs', 'BM25', 'BGE Embeddings'],
      description:
          'Developed a hybrid API discovery system using BM25, BGE embeddings, HyDE, and reranking models. '
          'Achieved Hit@20 = 0.80 with lower inference cost vs GPT-4 based retrieval.',
      githubUrl: 'https://github.com/rudrapratap19/LLM-BasedRESTful-WebAPIServiceDiscovery',
      demoUrl: null,
      color: AppColors.violet,
      icon: Icons.science_rounded,
      metrics: ['Hit@20 = 0.80', 'Lower Latency', 'vs GPT-4'],
    ),
    _Project(
      title: 'ArenaFlow',
      subtitle: '🏆 Tournament Management App',
      tags: ['Flutter', 'Firebase', 'BLoC', 'Dart'],
      description:
          'Full-featured sports tournament platform with real-time match tracking, live commentary, '
          'and automated brackets. Optimized Firestore queries using caching, pagination, and indexing.',
      githubUrl: 'https://github.com/rudrapratap19/ArenaFlow-main',
      demoUrl:
          'https://drive.google.com/file/d/1GeMb2HCN0hkSdPhskY6YRqBVq9HJMIPl/view?usp=drive_link',
      color: AppColors.cyan,
      icon: Icons.sports_esports_rounded,
      metrics: ['25+ Screens', '100+ Users', 'Real-time'],
    ),
    _Project(
      title: 'Decoder-Only Transformer\nfor Language Modeling',
      subtitle: '🤖 Generative LLM Architecture',
      tags: ['Python', 'PyTorch', 'Transformers', 'NLP'],
      description:
          'Implemented an autoregressive decoder-only Transformer model from scratch in PyTorch, '
          'featuring multi-head self-attention and positional encodings for sequence generation.',
      githubUrl:
          'https://github.com/rudrapratap19/Decoder-Only-Transformer-for-Language-Modeling',
      demoUrl: null,
      color: AppColors.pink,
      icon: Icons.psychology_rounded,
      metrics: ['PyTorch', 'Self-Attention', 'LLMs'],
    ),
    _Project(
      title: 'Flutter Task & To-Do App',
      subtitle: '📱 Cross-Platform Task Manager',
      tags: ['Flutter', 'Dart', 'Provider', 'Local Storage'],
      description:
          'Clean and intuitive task management application built with Flutter, '
          'featuring category filtering, dark mode, persistent storage, and smooth animations.',
      githubUrl: 'https://github.com/rudrapratap19/flutter-todo-app',
      demoUrl: null,
      color: AppColors.indigo,
      icon: Icons.task_alt_rounded,
      metrics: ['Flutter', 'Dart', 'State Mgmt'],
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
          isDesktop
              ? Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: _projects.asMap().entries.map((e) {
                    return SizedBox(
                      width: 400, // Fixed width for nice grid
                      child: _ProjectCard(project: e.value, delay: e.key * 150),
                    );
                  }).toList(),
                )
              : Column(
                  children: _projects.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _ProjectCard(project: e.value, delay: e.key * 150),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'WHAT I\'VE BUILT',
          style: GoogleFonts.inter(
            color: AppColors.cyan,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          'Projects',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
          gradient: const LinearGradient(
            colors: [AppColors.purple, AppColors.cyan],
          ),
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

class _Project {
  final String title;
  final String subtitle;
  final List<String> tags;
  final String description;
  final String? githubUrl;
  final String? demoUrl;
  final Color color;
  final IconData icon;
  final List<String> metrics;

  const _Project({
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.description,
    required this.githubUrl,
    required this.demoUrl,
    required this.color,
    required this.icon,
    required this.metrics,
  });
}

class _ProjectCard extends StatefulWidget {
  final _Project project;
  final int delay;

  const _ProjectCard({required this.project, required this.delay});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.project;

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode != AppThemeMode.light;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedSlide(
            offset: _isHovered ? const Offset(0, -0.04) : Offset.zero,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            child: GlassCard(
              enableHover: true,
              glowColor: p.color,
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon & Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              p.color.withValues(alpha: 0.3),
                              p.color.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: p.color.withValues(alpha: 0.3)),
                        ),
                        child: Icon(p.icon, color: p.color, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          p.subtitle,
                          style: GoogleFonts.inter(
                            color: p.color,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Title
                  Text(
                    p.title,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.getTextPrimary(isDark),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    p.description,
                    style: GoogleFonts.inter(
                      color: AppColors.getTextSecondary(isDark),
                      fontSize: 13,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Metrics
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: p.metrics.map((m) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: p.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m,
                          style: GoogleFonts.inter(
                            color: p.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: p.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: AppColors.getCardBorder(isDark),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.inter(
                            color: AppColors.getTextSecondary(isDark),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

              const SizedBox(height: 20),
              const Divider(color: AppColors.glassBorder, height: 1),
              const SizedBox(height: 16),

              // Links
              Row(
                children: [
                  if (p.githubUrl != null)
                    _LinkButton(
                      label: 'GitHub',
                      icon: Icons.code_rounded,
                      url: p.githubUrl!,
                      color: p.color,
                    ),
                  if (p.githubUrl != null && p.demoUrl != null)
                    const SizedBox(width: 12),
                  if (p.demoUrl != null)
                    _LinkButton(
                      label: 'Demo',
                      icon: Icons.play_circle_outline_rounded,
                      url: p.demoUrl!,
                      color: p.color,
                    ),
                  if (p.githubUrl == null && p.demoUrl == null)
                    Text(
                      '🔬 Research in Progress',
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ));
    },
  )
      .animate()
      .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 700.ms)
      .slideY(begin: 0.15);
  }
}

class _LinkButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final String url;
  final Color color;

  const _LinkButton({
    required this.label,
    required this.icon,
    required this.url,
    required this.color,
  });

  @override
  State<_LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<_LinkButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _isHovered
                ? widget.color.withOpacity(0.2)
                : widget.color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.color.withOpacity(_isHovered ? 0.6 : 0.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.color, size: 15),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  color: widget.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
