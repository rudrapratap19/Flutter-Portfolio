import 'package:flutter/material.dart';
import 'scroll_trigger_animator.dart';

class AnimatedCounterText extends StatelessWidget {
  final int targetValue;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;

  const AnimatedCounterText({
    super.key,
    required this.targetValue,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  Widget build(BuildContext context) {
    return ScrollTriggerAnimator(
      duration: duration,
      builder: (context, animValue, _) {
        final currentValue = (animValue * targetValue).round();
        return Text(
          '$prefix$currentValue$suffix',
          style: style,
        );
      },
    );
  }
}
