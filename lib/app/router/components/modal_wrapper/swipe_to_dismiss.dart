// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/utils/future.dart';

enum SwipeDismissDirection {
  vertical,
  horizontal,
  none,
}

/// Widget that allows you to dismiss content by swiping,
/// with proper handling of gesture conflicts during zoom
class SwipeToDismiss extends HookWidget {
  const SwipeToDismiss({
    required this.child,
    required this.onDismissed,
    this.isZoomed = false,
    this.dismissThreshold = 0.2,
    this.backgroundColor = Colors.black,
    this.direction = SwipeDismissDirection.vertical,
    this.minScale = 0.85,
    this.maxRadius = 30.0,
    this.minRadius = 7.0,
    super.key,
  });

  final VoidCallback onDismissed;
  final bool isZoomed;
  final Widget child;
  final double dismissThreshold;
  final Color backgroundColor;
  final SwipeDismissDirection direction;
  final double minScale;
  final double maxRadius;
  final double minRadius;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: 300.ms);
    final dragOffset = useState<double>(0);

    final radius = useMemoized(
      () {
        if (dragOffset.value == 0) return minRadius;

        final size = MediaQuery.of(context).size;
        final dragProgress = dragOffset.value.abs() / (size.height / 2);
        final clampedProgress = dragProgress.clamp(0.0, 1.0);

        return minRadius + (maxRadius - minRadius) * clampedProgress;
      },
      [dragOffset.value, minRadius, maxRadius],
    );

    final scale = useMemoized(
      () {
        if (dragOffset.value == 0) return 1.0;

        final size = MediaQuery.of(context).size;
        final dragProgress = dragOffset.value.abs() / (size.height / 2);
        final clampedProgress = dragProgress.clamp(0.0, 1.0);

        return 1.0 - (1.0 - minScale) * clampedProgress;
      },
      [dragOffset.value, minScale],
    );

    final opacity = useMemoized(
      () {
        if (dragOffset.value == 0) return 1.0;

        final size = MediaQuery.of(context).size;
        final dragProgress = dragOffset.value.abs() / (size.height / 2);
        final clampedProgress = dragProgress.clamp(0.0, 1.0);

        return 1.0 - 0.8 * clampedProgress;
      },
      [dragOffset.value],
    );

    useEffect(
      () {
        void listener() {
          dragOffset.value = animationController.value * dragOffset.value;

          if (animationController.isCompleted) {
            dragOffset.value = 0;
          }
        }

        animationController.addListener(listener);
        return () => animationController.removeListener(listener);
      },
      [animationController],
    );

    final shouldDismiss = useCallback(
      () {
        final threshold = MediaQuery.of(context).size.height * dismissThreshold;
        return dragOffset.value.abs() > threshold;
      },
      [dismissThreshold, dragOffset.value],
    );

    final handleDragStart = useCallback(
      (DragStartDetails details) {
        if (isZoomed) return;

        dragOffset.value = 0;
      },
      [isZoomed],
    );

    final handleDragUpdate = useCallback(
      (DragUpdateDetails details) {
        if (isZoomed) return;

        if (direction == SwipeDismissDirection.vertical) {
          dragOffset.value += details.delta.dy;
        } else if (direction == SwipeDismissDirection.horizontal) {
          dragOffset.value += details.delta.dx;
        }
      },
      [isZoomed, direction, dragOffset],
    );

    final handleDragEnd = useCallback(
      (DragEndDetails details) {
        if (isZoomed) return;

        if (shouldDismiss()) {
          onDismissed();
        } else {
          animationController
            ..reset()
            ..forward();
        }
      },
      [isZoomed, shouldDismiss, onDismissed, animationController],
    );

    return RawGestureDetector(
      gestures: {
        VerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
          VerticalDragGestureRecognizer.new,
          (VerticalDragGestureRecognizer instance) {
            instance
              ..onStart = isZoomed ? null : handleDragStart
              ..onUpdate = isZoomed ? null : handleDragUpdate
              ..onEnd = isZoomed ? null : handleDragEnd;
          },
        ),
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: backgroundColor.withValues(alpha: opacity),
        child: Transform.translate(
          offset: Offset(
            direction == SwipeDismissDirection.horizontal ? dragOffset.value : 0,
            direction == SwipeDismissDirection.vertical ? dragOffset.value : 0,
          ),
          child: Transform.scale(
            scale: scale,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
