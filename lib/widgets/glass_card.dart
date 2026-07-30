import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/theme_notifier.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool enableHover;
  final Color? glowColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 16,
    this.enableHover = true,
    this.glowColor,
    this.onTap,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(PointerEvent _) {
    if (widget.enableHover) {
      setState(() => _isHovered = true);
      _controller.forward();
    }
  }

  void _onExit(PointerEvent _) {
    if (widget.enableHover) {
      setState(() => _isHovered = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;
        final glowColor = widget.glowColor ?? (isDark ? AppColors.purpleGlow : AppColors.indigo);

        final borderColor = _isHovered
            ? (widget.glowColor ?? (isDark ? AppColors.violet : AppColors.indigo)).withValues(alpha: isDark ? 0.35 : 0.5)
            : AppColors.getCardBorder(isDark);

        final cardBg = isDark ? Colors.white.withValues(alpha: 0.04) : Colors.white;

        return MouseRegion(
          onEnter: _onEnter,
          onExit: _onExit,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOutCubic,
                  width: widget.width,
                  height: widget.height,
                  transform: widget.enableHover && _isHovered
                      ? (Matrix4.identity()..translate(0.0, -5.0))
                      : Matrix4.identity(),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: borderColor,
                      width: 1,
                    ),
                    gradient: isDark
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.04),
                              Colors.white.withValues(alpha: 0.01),
                            ],
                          )
                        : null,
                    boxShadow: isDark
                        ? (_isHovered
                            ? [
                                BoxShadow(
                                  color: glowColor.withValues(alpha: 0.12 * _glowAnimation.value),
                                  blurRadius: 20,
                                  spreadRadius: 0,
                                ),
                              ]
                            : [])
                        : [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: _isHovered ? 0.08 : 0.04),
                              blurRadius: _isHovered ? 20 : 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: isDark
                        ? BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Padding(
                              padding: widget.padding,
                              child: child,
                            ),
                          )
                        : Padding(
                            padding: widget.padding,
                            child: child,
                          ),
                  ),
                );
              },
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
