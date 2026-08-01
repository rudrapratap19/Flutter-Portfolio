import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/live_stats_widget.dart';
import '../widgets/visitor_counter.dart';
import '../widgets/gradient_text.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Container(
          constraints: BoxConstraints(minHeight: size.height),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 80 : 24,
            vertical: 100,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                _buildAvatar(isDark)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOut),

                const SizedBox(height: 32),

                // Greeting
                Text(
                  'Hey there! 👋 I am',
                  style: GoogleFonts.inter(
                    color: AppColors.getTextSecondary(isDark),
                    fontSize: isDesktop ? 18 : 15,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.5,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 700.ms).slideY(begin: 0.3),

                const SizedBox(height: 12),

                // Name
                AnimatedGradientText(
                  'Rudra Pratap Singh',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: isDesktop ? 68 : 38,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 800.ms)
                    .slideY(begin: 0.3),

                const SizedBox(height: 16),

                // Animated typing role
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'I am ',
                      style: GoogleFonts.inter(
                        color: AppColors.getTextSecondary(isDark),
                        fontSize: isDesktop ? 22 : 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    AnimatedTextKit(
                      repeatForever: true,
                      pause: const Duration(milliseconds: 500),
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'a Junior Flutter Developer',
                          textStyle: GoogleFonts.spaceGrotesk(
                            fontSize: isDesktop ? 22 : 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.violet,
                          ),
                          speed: const Duration(milliseconds: 80),
                        ),
                        TypewriterAnimatedText(
                          'an AI & DS Undergraduate',
                          textStyle: GoogleFonts.spaceGrotesk(
                            fontSize: isDesktop ? 22 : 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cyan,
                          ),
                          speed: const Duration(milliseconds: 80),
                        ),
                        TypewriterAnimatedText(
                          'a Backend & Mobile App Dev',
                          textStyle: GoogleFonts.spaceGrotesk(
                            fontSize: isDesktop ? 22 : 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.indigo,
                          ),
                          speed: const Duration(milliseconds: 80),
                        ),
                        TypewriterAnimatedText(
                          'Problem Solver',
                          textStyle: GoogleFonts.spaceGrotesk(
                            fontSize: isDesktop ? 22 : 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.pink,
                          ),
                          speed: const Duration(milliseconds: 80),
                        ),
                      ],
                    ),
                  ],
                ).animate().fadeIn(delay: 600.ms, duration: 700.ms),

                const SizedBox(height: 20),

                // Short bio
                Container(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    'B.Tech in AI & Data Science at IIIT Raichur. Building elegant, '
                    'production-ready Flutter apps and backend systems. Passionate about '
                    'ML, competitive programming, and open source.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.getTextSecondary(isDark),
                      fontSize: isDesktop ? 16 : 13,
                      height: 1.8,
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 700.ms),

                const SizedBox(height: 40),

                // CTA Buttons
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    _GradientButton(
                      label: 'Resume',
                      icon: Icons.description_rounded,
                      onTap: () => launchUrl(Uri.parse('Resume.pdf')),
                    ),
                    _OutlineButton(
                      label: 'Contact Me',
                      icon: Icons.email_outlined,
                      onTap: () => launchUrl(Uri.parse('mailto:rpsinghiiitr@gmail.com')),
                      isDark: isDark,
                    ),
                    _OutlineButton(
                      label: 'GitHub',
                      icon: Icons.link_rounded,
                      onTap: () => launchUrl(Uri.parse('https://github.com/rudrapratap19')),
                      isDark: isDark,
                    ),
                  ],
                ).animate().fadeIn(delay: 900.ms, duration: 700.ms).slideY(begin: 0.2),

                const SizedBox(height: 20),

                // Visitor counter pill
                _buildVisitorCounter(isDark),

                const SizedBox(height: 40),

                // Live stats row — fetched from GitHub & LeetCode APIs
                const LiveStatsRow(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVisitorCounter(bool isDark) {
    return VisitorCounter(isDark: isDark);
  }

  Widget _buildAvatar(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow ring
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                isDark ? AppColors.purple : AppColors.indigo,
                AppColors.violet,
                AppColors.cyan,
                isDark ? AppColors.purple : AppColors.indigo,
              ],
            ),
          ),
        ),
        // Inner container
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.getBackground(isDark),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/profile.jpg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.surface,
                child: Center(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        AppColors.primaryGradient.createShader(bounds),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.purple, AppColors.violet],
            ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.purple.withValues(alpha: 0.6),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.purple.withValues(alpha: 0.3),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDark = true,
  });

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isDark ? AppColors.violet : AppColors.indigo;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: _isHovered
                  ? activeColor
                  : (widget.isDark ? Colors.white.withValues(alpha: 0.15) : AppColors.lightBorder),
            ),
            color: _isHovered
                ? activeColor.withValues(alpha: 0.1)
                : (widget.isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: _isHovered ? activeColor : AppColors.getTextSecondary(widget.isDark),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  color: _isHovered ? activeColor : AppColors.getTextSecondary(widget.isDark),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
