import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ScrollTriggerAnimator extends StatefulWidget {
  final Widget Function(BuildContext context, double animationValue, Widget? child) builder;
  final Widget? child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double visibilityThreshold;

  const ScrollTriggerAnimator({
    super.key,
    required this.builder,
    this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = Duration.zero,
    this.curve = Curves.easeOutCubic,
    this.visibilityThreshold = 0.1,
  });

  @override
  State<ScrollTriggerAnimator> createState() => _ScrollTriggerAnimatorState();
}

class _ScrollTriggerAnimatorState extends State<ScrollTriggerAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _animation;
  bool _triggered = false;
  late Key _visibilityKey;

  @override
  void initState() {
    super.initState();
    _visibilityKey = UniqueKey();
    
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _ctrl, curve: widget.curve);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_triggered && info.visibleFraction >= widget.visibilityThreshold) {
      _triggered = true;
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => widget.builder(context, _animation.value, child),
        child: widget.child,
      ),
    );
  }
}
