import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class Navbar extends StatefulWidget {
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  const Navbar({
    super.key,
    required this.scrollController,
    required this.sectionKeys,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _isScrolled = false;

  final List<String> _navItems = [
    'About',
    'Live Stats',
    'Skills',
    'Experience',
    'Projects',
    'Roadmap & Credentials',
    'Contact',
  ];

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final scrolled = widget.scrollController.offset > 50;
    if (scrolled != _isScrolled) setState(() => _isScrolled = scrolled);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _scrollToSection(int index) {
    final key = widget.sectionKeys[index];
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: _isScrolled
            ? AppColors.background.withOpacity(0.92)
            : Colors.transparent,
        border: _isScrolled
            ? const Border(
                bottom: BorderSide(color: AppColors.glassBorder, width: 1),
              )
            : null,
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          // Logo / Name
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              'Rudra.',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const Spacer(),
          if (isDesktop)
            Row(
              children: List.generate(_navItems.length, (i) {
                return _NavItem(
                  label: _navItems[i],
                  onTap: () => _scrollToSection(i),
                );
              }),
            )
          else
            _MobileMenuButton(
              navItems: _navItems,
              onItemTap: _scrollToSection,
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
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
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: _isHovered
              ? const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.violet, width: 2),
                  ),
                )
              : null,
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: _isHovered ? AppColors.violet : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuButton extends StatelessWidget {
  final List<String> navItems;
  final Function(int) onItemTap;

  const _MobileMenuButton({required this.navItems, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.menu, color: AppColors.textPrimary),
      color: AppColors.surface,
      itemBuilder: (context) => navItems
          .asMap()
          .entries
          .map(
            (e) => PopupMenuItem<int>(
              value: e.key,
              child: Text(
                e.value,
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
              ),
            ),
          )
          .toList(),
      onSelected: onItemTap,
    );
  }
}
