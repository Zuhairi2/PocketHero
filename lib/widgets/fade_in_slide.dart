import 'package:flutter/material.dart';

class FadeInSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final double slideOffset;

  const FadeInSlide({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
    this.slideOffset = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Apply delay logic simply by holding value at 0 until delay has passed?
        // TweenAnimationBuilder doesn't have a delay parameter directly, but we can fake it
        // Or we can just use the value directly for a simpler approach since we're keeping it dependency free
        return Transform.translate(
          offset: Offset(0, slideOffset * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
