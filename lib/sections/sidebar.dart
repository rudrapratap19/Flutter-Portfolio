import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // We can use standard icons if this isn't available. Wait, let's stick to standard Material icons + cupertino to be safe.

class Sidebar extends StatefulWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  const Sidebar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int _activeIndex = 0;

  final List<({String label, IconData icon})> _navItems = [
    (label: 'Home', icon: Icons.person_outline),
    (label: 'About', icon: Icons.tag), // #
    (label: 'Live Stats', icon: Icons.data_usage),
    (label: 'Skills', icon: Icons.memory),
    (label: 'Experience', icon: Icons.work_outline),
    (label: 'Projects', icon: Icons.layers_outlined),
    (label: 'Achievements', icon: Icons.emoji_events_outlined),
    (label: 'Contact', icon: Icons.mail_outline),
  ];

  void _scrollToSection(int index) {
    setState(() => _activeIndex = index);

    // If "Home" is index 0, we scroll to top. But our sectionKeys start at 0 for "About".
    // So index 0 = scroll to top.
    // index 1 = About (sectionKeys[0])
    // index 2 = Live Stats (sectionKeys[1]), etc.

    if (index == 0) {
      widget.scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
      return;
    }

    final keyIndex = index - 1;
    if (keyIndex >= 0 && keyIndex < widget.sectionKeys.length) {
      final key = widget.sectionKeys[keyIndex];
      final context = key.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF070B14), // Deep dark background
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Profile Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.violet, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/profile.jpg'), // Assuming you have a profile picture here, fallback to network or placeholder otherwise
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.violet.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, color: Colors.transparent), // Fallback if image fails
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rudra Pratap',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Flutter Developer',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Open to Work Pill
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Open to Work',
                  style: GoogleFonts.inter(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // View Resume Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => launchUrl(Uri.parse('assets/Resume.pdf')),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.description_outlined, color: AppColors.violet, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'View Resume',
                        style: GoogleFonts.inter(
                          color: AppColors.violet,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 16),
          
          // Navigation Links
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isActive = _activeIndex == index;

                return _SidebarItem(
                  label: item.label,
                  icon: item.icon,
                  isActive: isActive,
                  onTap: () => _scrollToSection(index),
                );
              },
            ),
          ),

          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 16),
          
          // Footer Socials
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SocialIcon(
                  icon: Icons.link, // GitHub replacement
                  url: 'https://github.com/rudrapratap19',
                  tooltip: 'GitHub',
                ),
                _SocialIcon(
                  icon: Icons.work, // LinkedIn replacement
                  url: 'https://linkedin.com/in/rudra-pratap-singh-677149314',
                  tooltip: 'LinkedIn',
                ),
                _SocialIcon(
                  icon: Icons.code, // Leetcode replacement
                  url: 'https://leetcode.com/u/rpsinghiiitr/',
                  tooltip: 'LeetCode',
                ),
                _SocialIcon(
                  icon: Icons.email,
                  url: 'mailto:rpsinghiiitr@gmail.com',
                  tooltip: 'Email',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isActive
        ? AppColors.violet
        : (_isHovered ? Colors.white : AppColors.textMuted);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.violet.withValues(alpha: 0.1)
                : (_isHovered ? Colors.white.withValues(alpha: 0.05) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: color, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    color: color,
                    fontSize: 14,
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (widget.isActive)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.violet,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => launchUrl(Uri.parse(widget.url)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              color: _isHovered ? Colors.white : AppColors.textMuted,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
