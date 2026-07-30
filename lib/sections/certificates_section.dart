import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';

class CertificatesSection extends StatelessWidget {
  const CertificatesSection({super.key});

  static const _certificates = [
    (
      icon: FontAwesomeIcons.medal,
      title: 'Naukri Campus Young Turks 2025',
      issuer: 'Certificate of Merit (99.40 Percentile)',
      date: 'Sep 29, 2025',
      url: 'assets/Certificates/Certificates/young_turks25_round_1_achievement.pdf',
      color: AppColors.purple,
    ),
    (
      icon: FontAwesomeIcons.code,
      title: 'Flutter & Dart - The Complete Guide',
      issuer: 'Maximilian Schwarzmüller (Udemy)',
      date: 'Oct 15, 2025',
      url: 'https://ude.my/UC-3efc93b0-0b5c-41c5-af36-730c55c06090',
      color: AppColors.cyan,
    ),
    (
      icon: FontAwesomeIcons.terminal,
      title: 'Learn C++ Programming - Deep Dive',
      issuer: 'Abdul Bari (Udemy)',
      date: 'Jun 18, 2025',
      url: 'https://ude.my/UC-455f8879-0284-4d71-808a-356f01d03f5d',
      color: AppColors.violet,
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
          'CREDENTIALS',
          style: GoogleFonts.inter(
            color: AppColors.cyan,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          'Certifications',
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
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildDesktopGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.9,
      ),
      itemCount: _certificates.length,
      itemBuilder: (context, index) {
        return _buildCertificateCard(_certificates[index], index);
      },
    );
  }

  Widget _buildMobileList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _certificates.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildCertificateCard(_certificates[index], index);
      },
    );
  }

  Widget _buildCertificateCard(dynamic cert, int index) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, _) {
        final isDark = mode == AppThemeMode.dark;
        return GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cert.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FaIcon(cert.icon, color: cert.color, size: 24),
              ),
              const SizedBox(height: 20),
              Text(
                cert.title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(isDark),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                cert.issuer,
                style: GoogleFonts.inter(
                  color: AppColors.getTextSecondary(isDark),
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cert.date,
                    style: GoogleFonts.inter(
                      color: AppColors.getTextMuted(isDark),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => launchUrl(Uri.parse(cert.url)),
                    icon: Icon(Icons.open_in_new, size: 16, color: cert.color),
                    label: Text(
                      'View',
                      style: GoogleFonts.inter(
                        color: cert.color,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: cert.color.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1);
      },
    );
  }
}
