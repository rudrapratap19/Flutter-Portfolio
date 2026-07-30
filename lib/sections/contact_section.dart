import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/platform_stats.dart';
import '../services/api_service.dart';
import '../services/email_service.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';
import '../services/email_service.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

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
          const SizedBox(height: 20),
          // Tagline
          Container(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              "I'm currently open to new opportunities. Whether you have a question, "
              "a project idea, or just want to say hi — my inbox is always open!",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.7,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
          // Contact Form UI
          const _ContactForm(),
          const SizedBox(height: 60),

          // Live platform stats panel
          const _LivePlatformPanel(),

          const SizedBox(height: 80),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "LET'S TALK",
          style: GoogleFonts.inter(
            color: AppColors.violet,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          'Get In Touch',
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
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Container(height: 1, color: AppColors.glassBorder),
        const SizedBox(height: 24),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: Text(
            'Rudra.',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'B.Tech AI & DS • IIIT Raichur • Flutter Developer',
          style: GoogleFonts.inter(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '© 2025 Rudra Pratap Singh. Built with Flutter 💙',
          style: GoogleFonts.inter(
            color: AppColors.textMuted,
            fontSize: 12,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 600.ms);
  }
}

// ─── Live Platform Panel ───────────────────────────────────────────────────────

class _LivePlatformPanel extends StatefulWidget {
  const _LivePlatformPanel();

  @override
  State<_LivePlatformPanel> createState() => _LivePlatformPanelState();
}

class _LivePlatformPanelState extends State<_LivePlatformPanel> {
  AllStats? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await ApiService.fetchAllStats();
    if (mounted) setState(() { _stats = s; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final lc = _stats?.leetcode ?? LeetCodeStats.fallback;
    final gh = _stats?.github ?? GitHubStats.fallback;

    final contacts = [
      _PlatformCard(
        icon: Icons.email_rounded,
        label: 'Email',
        title: 'rpsinghiiitr@gmail.com',
        subtitle: 'Best way to reach me',
        url: 'mailto:rpsinghiiitr@gmail.com',
        color: AppColors.violet,
        stat: null,
        isLoading: false,
      ),
      _PlatformCard(
        icon: Icons.code_rounded,
        label: 'GitHub',
        title: 'github.com/rudrapratap19',
        subtitle: _loading
            ? 'Loading...'
            : '${gh.publicRepos} repos • ${gh.totalStars} ⭐',
        url: 'https://github.com/rudrapratap19',
        color: AppColors.purple,
        stat: _loading ? null : '${gh.publicRepos}',
        isLoading: _loading,
      ),
      _PlatformCard(
        icon: Icons.link_rounded,
        label: 'LinkedIn',
        title: 'Rudra Pratap Singh',
        subtitle: 'Connect professionally',
        url: 'https://www.linkedin.com/in/rudra-pratap-singh-677149314',
        color: AppColors.cyan,
        stat: null,
        isLoading: false,
      ),
      _PlatformCard(
        icon: Icons.leaderboard_rounded,
        label: 'LeetCode',
        title: 'rpsinghiiitr',
        subtitle: _loading
            ? 'Loading...'
            : '${lc.totalSolved} solved • Rating ${lc.contestRating.toStringAsFixed(0)}',
        url: 'https://leetcode.com/u/rpsinghiiitr/',
        color: AppColors.indigo,
        stat: _loading ? null : lc.contestRating.toStringAsFixed(0),
        isLoading: _loading,
      ),
      _PlatformCard(
        icon: Icons.functions_rounded,
        label: 'GeeksforGeeks',
        title: 'rpsinghlfb9',
        subtitle: '450+ score',
        url: 'https://www.geeksforgeeks.org/profile/rpsinghlfb9',
        color: AppColors.pink,
        stat: '450+',
        isLoading: false,
      ),
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: contacts.asMap().entries.map((e) {
        return _ContactCard(card: e.value, delay: e.key * 100);
      }).toList(),
    );
  }
}

class _PlatformCard {
  final IconData icon;
  final String label;
  final String title;
  final String subtitle;
  final String url;
  final Color color;
  final String? stat;
  final bool isLoading;

  const _PlatformCard({
    required this.icon,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.color,
    required this.stat,
    required this.isLoading,
  });
}

class _ContactCard extends StatefulWidget {
  final _PlatformCard card;
  final int delay;

  const _ContactCard({required this.card, required this.delay});

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.card;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () => launchUrl(Uri.parse(c.url)),
            child: AnimatedSlide(
              offset: _isHovered ? const Offset(0, -0.04) : Offset.zero,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              child: GlassCard(
                enableHover: true,
                glowColor: c.color,
                width: 220,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: c.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: c.color.withValues(alpha: 0.25)),
                          ),
                          child: Icon(c.icon, color: c.color, size: 20),
                        ),
                        const Spacer(),
                        if (c.isLoading)
                          SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: c.color,
                            ),
                          )
                        else
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.arrow_outward_rounded,
                              color: _isHovered ? c.color : AppColors.getTextMuted(isDark),
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Platform label
                    Text(
                      c.label.toUpperCase(),
                      style: GoogleFonts.inter(
                        color: AppColors.getTextMuted(isDark),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Title (username/handle)
                    Text(
                      c.title,
                      style: GoogleFonts.inter(
                        color: _isHovered ? c.color : AppColors.getTextPrimary(isDark),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                const SizedBox(height: 6),
                // Live subtitle (repos/rating/score)
                Row(
                  children: [
                    if (c.stat != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: c.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          c.stat!,
                          style: GoogleFonts.spaceGrotesk(
                            color: c.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        c.subtitle,
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ));
    },
  )
      .animate()
      .fadeIn(delay: Duration(milliseconds: widget.delay), duration: 600.ms)
      .slideY(begin: 0.2);
  }
}

// ─── Contact Form ─────────────────────────────────────────────────────────────

class _ContactForm extends StatefulWidget {
  const _ContactForm();

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  bool _isHovered = false;
  bool _isSubmitting = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final msg = _msgCtrl.text.trim();

    if (name.isEmpty || email.isEmpty || msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill out all fields.', style: GoogleFonts.inter()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await EmailService.sendContactEmail(
        name: name,
        email: email,
        subject: 'Portfolio Contact Form Message',
        message: msg,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Message sent successfully! Check your email.', style: GoogleFonts.inter()),
            backgroundColor: Colors.green,
          ),
        );
        _nameCtrl.clear();
        _emailCtrl.clear();
        _msgCtrl.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message. Please try again.', style: GoogleFonts.inter()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;

        return Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: GlassCard(
            glowColor: AppColors.violet,
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Send me a message',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.getTextPrimary(isDark),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 450;
                    if (isSmall) {
                      return Column(
                        children: [
                          _buildTextField(
                            hint: 'Your Name',
                            icon: Icons.person_outline_rounded,
                            controller: _nameCtrl,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            hint: 'Your Email',
                            icon: Icons.email_outlined,
                            controller: _emailCtrl,
                            isDark: isDark,
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            hint: 'Your Name',
                            icon: Icons.person_outline_rounded,
                            controller: _nameCtrl,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            hint: 'Your Email',
                            icon: Icons.email_outlined,
                            controller: _emailCtrl,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  hint: 'Message',
                  icon: Icons.message_outlined,
                  maxLines: 4,
                  controller: _msgCtrl,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),
                MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: GestureDetector(
                    onTap: _isSubmitting ? null : _submit,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isSubmitting
                              ? [Colors.grey.shade700, Colors.grey.shade600]
                              : [AppColors.violet, AppColors.cyan],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _isHovered && !_isSubmitting
                            ? [
                                BoxShadow(
                                  color: AppColors.violet.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  spreadRadius: 0,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: AppColors.violet.withValues(alpha: 0.08),
                                  blurRadius: 8,
                                ),
                              ],
                      ),
                      child: Center(
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Send Message 🚀',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1);
      },
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
    bool isDark = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.getCardBorder(isDark)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.inter(
          color: AppColors.getTextPrimary(isDark),
          fontSize: 14,
        ),
        decoration: InputDecoration(
          icon: Padding(
            padding: EdgeInsets.only(bottom: maxLines > 1 ? 60 : 0),
            child: Icon(icon, color: AppColors.getTextMuted(isDark), size: 20),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: AppColors.getTextMuted(isDark),
            fontSize: 14,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
