import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'theme/theme_notifier.dart';
import 'widgets/star_background.dart';
import 'widgets/cursor_effect.dart';
import 'widgets/reveal_widget.dart';
import 'sections/sidebar.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/skills_section.dart';
import 'sections/experience_section.dart';
import 'sections/projects_section.dart';
// import 'sections/achievements_section.dart';
import 'sections/contact_section.dart';
import 'sections/stats_graphs_section.dart';
import 'sections/terminal_view.dart';
import 'sections/achievements_tree_section.dart';
import 'widgets/cmd_prompt_dialog.dart';
import 'widgets/ai_chatbot.dart';
import 'dart:async';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'Rudra Pratap Singh | Flutter & AI Developer',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeNotifier.instance.materialThemeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: mode == AppThemeMode.cmd
              ? const TerminalView()
              : const PortfolioHome(),
        );
      },
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(7, (_) => GlobalKey());
  bool _hasPromptedCmd = false;
  Timer? _cmdTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Relevant timing fallback: 8 seconds after launch
    _cmdTimer = Timer(const Duration(seconds: 8), () {
      _triggerCmdPrompt();
    });
  }

  void _onScroll() {
    if (_scrollController.offset > 350) {
      _triggerCmdPrompt();
    }
  }

  void _triggerCmdPrompt() {
    if (!_hasPromptedCmd && ThemeNotifier.instance.isLightMode && mounted) {
      _hasPromptedCmd = true;
      _cmdTimer?.cancel();
      CmdPromptDialog.show(context);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _cmdTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return Scaffold(
          backgroundColor: AppColors.getBackground(isDark),
          drawer: isDesktop
              ? null
              : Drawer(
                  child: Sidebar(
                    scrollController: _scrollController,
                    sectionKeys: _sectionKeys,
                  ),
                ),
          body: CursorEffect(
            child: StarBackground(
              child: Row(
                children: [
                  // Desktop Sidebar
                  if (isDesktop)
                    Sidebar(
                      scrollController: _scrollController,
                      sectionKeys: _sectionKeys,
                    ),

                  // Main Content
                  Expanded(
                    child: Stack(
                      children: [
                        // Scroll content
                        NotificationListener<ScrollNotification>(
                          onNotification: (_) => true,
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                const SizedBox(height: 80),

                                // ── Hero ──
                                const HeroSection(),

                                _divider(isDark),

                                // ── About ──
                                RevealWidget(
                                  key: _sectionKeys[0],
                                  child: const AboutSection(),
                                ),

                                _divider(isDark),

                                // ── Live Stats Graphs ──
                                RevealWidget(
                                  key: _sectionKeys[1],
                                  slideFrom: const Offset(0, 60),
                                  child: const StatsGraphsSection(),
                                ),

                                _divider(isDark),

                                // ── Skills ──
                                RevealWidget(
                                  key: _sectionKeys[2],
                                  child: const SkillsSection(),
                                ),

                                _divider(isDark),

                                // ── Experience ──
                                RevealWidget(
                                  key: _sectionKeys[3],
                                  child: const ExperienceSection(),
                                ),

                                _divider(isDark),

                                // ── Projects ──
                                RevealWidget(
                                  key: _sectionKeys[4],
                                  child: const ProjectsSection(),
                                ),

                                _divider(isDark),

                                // ── Achievements & Credentials Tree ──
                                RevealWidget(
                                  key: _sectionKeys[5],
                                  child: const AchievementsTreeSection(),
                                ),

                                _divider(isDark),

                                // ── Contact ──
                                RevealWidget(
                                  key: _sectionKeys[6],
                                  child: const ContactSection(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Mobile Hamburger Menu
                        if (!isDesktop)
                          Positioned(
                            top: 48,
                            left: 16,
                            child: SafeArea(
                              child: Builder(
                                builder: (context) => GestureDetector(
                                  onTap: () => Scaffold.of(context).openDrawer(),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white.withValues(alpha: 0.08)
                                          : Colors.white.withValues(alpha: 0.85),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white.withValues(alpha: 0.12)
                                            : AppColors.lightBorder,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.menu_rounded,
                                      color: AppColors.getTextPrimary(isDark),
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                        // AI Chatbot Floating Widget
                        const AiChatbot(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _divider(bool isDark) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 80),
        height: 1,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : AppColors.lightBorder,
        ),
      );
}
