import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ice/app/hooks/use_on_init.dart';

/// Animates a value between two heights based on a boolean condition.
///
/// This hook is useful for animating the appearance and disappearance of UI elements,
/// such as notifications or expandable content.
double useAnimatedExpandableHeight({
  required bool isExpanded,
  required double collapsedHeight,
  required double expandedHeight,
}) {
  final animationController = useAnimationController(duration: 300.ms);

  final animation = useAnimation(
    Tween<double>(
      begin: collapsedHeight,
      end: expandedHeight,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    ),
  );

  useOnInit(
    () => isExpanded ? animationController.forward() : animationController.reverse(),
    [isExpanded],
  );

  return animation;
}
