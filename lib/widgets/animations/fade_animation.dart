import 'package:flutter/material.dart';

class FadeAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double begin;
  final double end;
  
  const FadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.begin = 0.0,
    this.end = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: begin, end: end),
      duration: duration,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }
}