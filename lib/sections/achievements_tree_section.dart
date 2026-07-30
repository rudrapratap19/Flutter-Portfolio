import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_text.dart';

enum MilestoneCategory {
  all('All'),
  academics('Academics & DSA'),
  certifications('Certifications'),
  leadership('Leadership'),
  hackathons('Hackathons');

  final String label;
  const MilestoneCategory(this.label);
}

class MilestoneItem {
  final String title;
  final String categoryTag;
  final String subtitle;
  final String description;
  final String date;
  final IconData icon;
  final Color color;
  final String? url;
  final MilestoneCategory category;

  const MilestoneItem({
    required this.title,
    required this.categoryTag,
    required this.subtitle,
    required this.description,
    required this.date,
    required this.icon,
    required this.color,
    this.url,
    required this.category,
  });
}

class AchievementsTreeSection extends StatefulWidget {
  const AchievementsTreeSection({super.key});

  @override
  State<AchievementsTreeSection> createState() => _AchievementsTreeSectionState();
}

class _AchievementsTreeSectionState extends State<AchievementsTreeSection> {
  MilestoneCategory _selectedCategory = MilestoneCategory.all;

  static const List<MilestoneItem> _allMilestones = [
    MilestoneItem(
      title: 'District Topper (10th Board Exam)',
      categoryTag: 'ACADEMIC EXCELLENCE',
      subtitle: 'Secondary School Education',
      description: 'Secured 1st rank in the district in 10th Board Examinations for overall academic performance.',
      date: 'Honor',
      icon: Icons.workspace_premium_rounded,
      color: Color(0xFFFFD700),
      category: MilestoneCategory.academics,
    ),
    MilestoneItem(
      title: 'Naukri Campus Young Turks 2025',
      categoryTag: 'NATIONAL RANK',
      subtitle: '99.40 Percentile Merit',
      description: 'Scored 99.40 percentile nationwide in India\'s largest skill contest organized by Naukri Campus.',
      date: 'Sep 29, 2025',
      icon: Icons.military_tech_rounded,
      color: AppColors.purple,
      url: 'assets/Certificates/Certificates/young_turks25_round_1_achievement.pdf',
      category: MilestoneCategory.academics,
    ),
    MilestoneItem(
      title: 'GATE CS 2026 Qualified',
      categoryTag: 'COMPETITIVE EXAM',
      subtitle: 'Graduate Aptitude Test in Engineering',
      description: 'Qualified GATE Computer Science & Information Technology examination.',
      date: '2026',
      icon: Icons.school_rounded,
      color: AppColors.violet,
      category: MilestoneCategory.academics,
    ),
    MilestoneItem(
      title: 'Flutter & Dart - The Complete Guide',
      categoryTag: 'PROFESSIONAL CERT',
      subtitle: 'Maximilian Schwarzmüller (Udemy)',
      description: 'Mastered Flutter framework, state management (Provider, Bloc), custom animations, and native device features.',
      date: 'Oct 15, 2025',
      icon: Icons.code_rounded,
      color: AppColors.cyan,
      url: 'https://ude.my/UC-3efc93b0-0b5c-41c5-af36-730c55c06090',
      category: MilestoneCategory.certifications,
    ),
    MilestoneItem(
      title: 'Academic Affairs Secretary',
      categoryTag: 'STUDENT GOVERNANCE',
      subtitle: 'CoSA IIIT Raichur (2024-2025)',
      description: 'Elected student secretary leading academic initiatives for 600+ students & revived Aurora Club with 70%+ participation.',
      date: '2024 - 2025',
      icon: Icons.groups_rounded,
      color: AppColors.indigo,
      url: 'assets/Certificates/Certificates/Academic Secretary certificate .pdf',
      category: MilestoneCategory.leadership,
    ),
    MilestoneItem(
      title: 'LeetCode Top 5000 & 474+ Solved',
      categoryTag: 'PROBLEM SOLVING',
      subtitle: 'Global Rank < 5000 | 1450+ Rating',
      description: 'Solved 224+ problems on LeetCode and 250+ (Score 450+) on GeeksforGeeks with strong contest consistency.',
      date: 'Ongoing',
      icon: Icons.terminal_rounded,
      color: AppColors.cyan,
      category: MilestoneCategory.academics,
    ),
    MilestoneItem(
      title: 'Learn C++ Programming - Deep Dive',
      categoryTag: 'PROFESSIONAL CERT',
      subtitle: 'Abdul Bari (Udemy)',
      description: 'Comprehensive mastery of Data Structures, Algorithms, Object-Oriented Design, and Memory Management in C++.',
      date: 'Jun 18, 2025',
      icon: Icons.integration_instructions_rounded,
      color: AppColors.violet,
      url: 'https://ude.my/UC-455f8879-0284-4d71-808a-356f01d03f5d',
      category: MilestoneCategory.certifications,
    ),
    MilestoneItem(
      title: 'Placement Cell Coordinator',
      categoryTag: 'LEADERSHIP',
      subtitle: 'IIIT Raichur Placement Team',
      description: 'Coordinated with 15+ recruiters and improved student response efficiency by 25% through automated workflows.',
      date: '2026',
      icon: Icons.business_center_rounded,
      color: AppColors.pink,
      category: MilestoneCategory.leadership,
    ),
    MilestoneItem(
      title: 'Adobe India Hackathon 2025',
      categoryTag: 'HACKATHON',
      subtitle: 'Round 1 Qualifier (Team Gyaan Yoddha)',
      description: 'Selected in Round 1 Online MCQ Assessment + Coding of Adobe India Hackathon organized by Adobe.',
      date: '2025',
      icon: Icons.emoji_events_rounded,
      color: AppColors.pink,
      url: 'assets/Certificates/Certificates/Adobe round 1.pdf',
      category: MilestoneCategory.hackathons,
    ),
    MilestoneItem(
      title: 'L\'Oréal Sustainability Challenge 2025',
      categoryTag: 'COMPETITION',
      subtitle: 'Online Aptitude Qualifier',
      description: 'Qualified Online Aptitude Assessment of L\'Oréal Sustainability Challenge 2025 with Team Gyaan Yoddha.',
      date: '2025',
      icon: Icons.public_rounded,
      color: Color(0xFF22C55E),
      url: 'assets/Certificates/Certificates/Loreal.pdf',
      category: MilestoneCategory.hackathons,
    ),
  ];

  List<MilestoneItem> get _filteredMilestones {
    if (_selectedCategory == MilestoneCategory.all) return _allMilestones;
    return _allMilestones
        .where((m) => m.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 20,
        vertical: 80,
      ),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 36),
          _buildCategoryFilters(),
          const SizedBox(height: 56),
          isDesktop
              ? _buildDesktopTree(_filteredMilestones)
              : _buildMobileTimeline(_filteredMilestones),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'MILESTONES & ROADMAP',
          style: GoogleFonts.inter(
            color: AppColors.violet,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 8),
        GradientText(
          'Achievements & Credentials',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
          gradient: const LinearGradient(
            colors: [AppColors.violet, AppColors.pink],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.violet, AppColors.pink],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2);
  }

  Widget _buildCategoryFilters() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: MilestoneCategory.values.map((cat) {
        final isSelected = _selectedCategory == cat;
        return ValueListenableBuilder<AppThemeMode>(
          valueListenable: ThemeNotifier.instance,
          builder: (context, mode, _) {
            final isDark = mode == AppThemeMode.dark;
            return InkWell(
              onTap: () => setState(() => _selectedCategory = cat),
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected
                      ? null
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.04)),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.getCardBorder(isDark),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.violet.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  cat.label,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : AppColors.getTextPrimary(isDark),
                  ),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildDesktopTree(List<MilestoneItem> items) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Central Gradient Trunk
        Positioned(
          top: 20,
          bottom: 20,
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.violet, AppColors.cyan, AppColors.pink],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.violet.withValues(alpha: 0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ),
        // Alternating Cards
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final isLeft = index % 2 == 0;
            final item = items[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                children: [
                  // Left Side Container
                  Expanded(
                    child: isLeft
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 36),
                              child: _buildMilestoneCard(item, isLeft: true),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  // Center Node Badge
                  _buildCenterNode(item),
                  // Right Side Container
                  Expanded(
                    child: !isLeft
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 36),
                              child: _buildMilestoneCard(item, isLeft: false),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMobileTimeline(List<MilestoneItem> items) {
    return Stack(
      children: [
        // Left Stem Line
        Positioned(
          top: 20,
          bottom: 20,
          left: 17.5,
          child: Container(
            width: 3,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.violet, AppColors.cyan, AppColors.pink],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        // Vertical List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCenterNode(item, isMobile: true),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMilestoneCard(item, isLeft: false),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCenterNode(MilestoneItem item, {bool isMobile = false}) {
    return Container(
      width: isMobile ? 38 : 46,
      height: isMobile ? 38 : 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(color: item.color, width: 2),
        boxShadow: [
          BoxShadow(
            color: item.color.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          item.icon,
          size: isMobile ? 16 : 20,
          color: item.color,
        ),
      ),
    );
  }

  Widget _buildMilestoneCard(MilestoneItem item, {required bool isLeft}) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, _) {
        final isDark = mode == AppThemeMode.dark;

        return GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Tag & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: item.color.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      item.categoryTag,
                      style: GoogleFonts.inter(
                        color: item.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Text(
                    item.date,
                    style: GoogleFonts.inter(
                      color: AppColors.getTextMuted(isDark),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Title
              Text(
                item.title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.getTextPrimary(isDark),
                ),
              ),
              const SizedBox(height: 4),
              // Subtitle
              Text(
                item.subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.getTextSecondary(isDark),
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                item.description,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.getTextMuted(isDark),
                  height: 1.4,
                ),
              ),
              if (item.url != null) ...[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => launchUrl(Uri.parse(item.url!)),
                    icon: Icon(Icons.open_in_new, size: 14, color: item.color),
                    label: Text(
                      item.url!.startsWith('http') ? 'Verify Credential' : 'View Certificate PDF',
                      style: GoogleFonts.inter(
                        color: item.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      backgroundColor: item.color.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
      },
    );
  }
}
