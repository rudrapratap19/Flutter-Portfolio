import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/theme_notifier.dart';

class StarParticle {
  late double x;
  late double y;
  late double size;
  late double opacity;
  late double speed;
  late double twinklePhase;

  StarParticle(Random random, double width, double height) {
    x = random.nextDouble() * width;
    y = random.nextDouble() * height;
    size = random.nextDouble() * 2.5 + 0.5;
    opacity = random.nextDouble() * 0.7 + 0.1;
    speed = random.nextDouble() * 0.3 + 0.1;
    twinklePhase = random.nextDouble() * 2 * pi;
  }
}

class StarBackgroundPainter extends CustomPainter {
  final List<StarParticle> stars;
  final double animationValue;

  StarBackgroundPainter({required this.stars, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle = (sin(animationValue * 2 * pi + star.twinklePhase) + 1) / 2;
      final opacity = star.opacity * (0.4 + 0.6 * twinkle);
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(star.x, star.y),
        star.size * (0.8 + 0.2 * twinkle),
        paint,
      );
    }

    // Nebula glow — top right
    final nebulaGradient1 = RadialGradient(
      colors: [
        const Color(0xFF7C3AED).withValues(alpha: 0.12),
        const Color(0xFF7C3AED).withValues(alpha: 0.0),
      ],
      radius: 0.6,
    );
    final rect1 = Rect.fromCenter(
      center: Offset(size.width * 0.85, size.height * 0.15),
      width: size.width * 0.8,
      height: size.width * 0.8,
    );
    canvas.drawOval(rect1, Paint()..shader = nebulaGradient1.createShader(rect1));

    // Nebula glow — bottom left
    final nebulaGradient2 = RadialGradient(
      colors: [
        const Color(0xFF06B6D4).withValues(alpha: 0.08),
        const Color(0xFF06B6D4).withValues(alpha: 0.0),
      ],
      radius: 0.6,
    );
    final rect2 = Rect.fromCenter(
      center: Offset(size.width * 0.1, size.height * 0.8),
      width: size.width * 0.7,
      height: size.width * 0.7,
    );
    canvas.drawOval(rect2, Paint()..shader = nebulaGradient2.createShader(rect2));
  }

  @override
  bool shouldRepaint(StarBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class StarBackground extends StatefulWidget {
  final Widget child;
  const StarBackground({super.key, required this.child});

  @override
  State<StarBackground> createState() => _StarBackgroundState();
}

class _StarBackgroundState extends State<StarBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<StarParticle> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initStars(Size size) {
    if (_stars.isEmpty) {
      _stars = List.generate(
        180,
        (_) => StarParticle(_random, size.width, size.height),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeMode>(
      valueListenable: ThemeNotifier.instance,
      builder: (context, mode, child) {
        final isDark = mode == AppThemeMode.dark;

        return LayoutBuilder(
          builder: (context, constraints) {
            _initStars(Size(constraints.maxWidth, constraints.maxHeight));

            return Stack(
              children: [
                // Background color
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0B1020) : const Color(0xFFF8FAFC),
                    gradient: isDark
                        ? const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF0B1020), Color(0xFF070D1A)],
                          )
                        : null,
                  ),
                ),
                // Animated stars (Dark mode only)
                if (isDark)
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: StarBackgroundPainter(
                          stars: _stars,
                          animationValue: _controller.value,
                        ),
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                      );
                    },
                  ),
                widget.child,
              ],
            );
          },
        );
      },
    );
  }
}
