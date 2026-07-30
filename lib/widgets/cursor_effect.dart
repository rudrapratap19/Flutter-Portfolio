import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Renders a glowing cursor dot that follows the mouse.
/// Wraps the entire app — add as root Stack child.
class CursorEffect extends StatefulWidget {
  final Widget child;
  const CursorEffect({super.key, required this.child});

  @override
  State<CursorEffect> createState() => _CursorEffectState();
}

class _CursorEffectState extends State<CursorEffect>
    with SingleTickerProviderStateMixin {
  Offset _cursor = Offset.zero;
  Offset _target = Offset.zero;
  late AnimationController _ctrl;
  bool _visible = false;
  bool _clicking = false;

  // Trail positions
  final List<Offset> _trail = [];
  static const _trailLength = 6;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..addListener(_tick);
    _ctrl.repeat();
  }

  void _tick() {
    if (!mounted) return;
    // Smooth follow
    _cursor = Offset(
      _cursor.dx + (_target.dx - _cursor.dx) * 0.18,
      _cursor.dy + (_target.dy - _cursor.dy) * 0.18,
    );

    // Update trail
    _trail.insert(0, _cursor);
    if (_trail.length > _trailLength) _trail.removeLast();

    setState(() {});
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (e) => setState(() {
        _visible = true;
        _target = e.position;
        _cursor = e.position;
      }),
      onExit: (_) => setState(() => _visible = false),
      onHover: (e) => _target = e.position,
      child: Listener(
        onPointerDown: (_) => setState(() => _clicking = true),
        onPointerUp: (_) => setState(() => _clicking = false),
        child: Stack(
          children: [
            widget.child,
            if (_visible) ...[
              // Trail dots
              ..._trail.asMap().entries.map((entry) {
                final i = entry.key;
                final pos = entry.value;
                final progress = 1.0 - (i / _trailLength);
                final size = 6.0 * progress;
                return Positioned(
                  left: pos.dx - size / 2,
                  top: pos.dy - size / 2,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.25 * progress,
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.violet,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              // Main glow ring
              Positioned(
                left: _cursor.dx - 20,
                top: _cursor.dy - 20,
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: _clicking ? 28 : 40,
                    height: _clicking ? 28 : 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.violet.withValues(alpha: 0.6),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withValues(alpha: 0.25),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Inner dot
              Positioned(
                left: _cursor.dx - 3,
                top: _cursor.dy - 3,
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: _clicking ? 8 : 6,
                    height: _clicking ? 8 : 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.violet,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
