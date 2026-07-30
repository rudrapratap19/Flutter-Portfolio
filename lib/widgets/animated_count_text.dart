import 'package:flutter/material.dart';

/// Animated counter widget that smoothly ticks up from 0 to targetValue.
class AnimatedCountText extends StatelessWidget {
  final int targetValue;
  final String suffix;
  final TextStyle style;
  final Duration duration;
  final Curve curve;

  const AnimatedCountText({
    super.key,
    required this.targetValue,
    this.suffix = '+',
    required this.style,
    this.duration = const Duration(milliseconds: 1200),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: targetValue.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        return Text(
          '${value.toInt()}$suffix',
          style: style,
        );
      },
    );
  }
}
