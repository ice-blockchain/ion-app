// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/utils/future.dart';

enum SwipeDismissDirection {
  vertical,
  multi,
  none,
}

/// Widget for dismissing content with swipe.
/// Support for directions:
/// - vertical – only along the Y axis,
/// - multi – any direction (two-dimensional),
/// - none – disable swipes.
class DismissiblePage extends HookWidget {
  const DismissiblePage({
    required this.child,
    required this.onDismissed,
    this.isZoomed = false,
    this.dismissThreshold = 0.2,
    this.backgroundColor = Colors.black,
    this.direction = SwipeDismissDirection.vertical,
    this.minScale = 0.85,
    this.maxRadius = 30.0,
    this.minRadius = 7.0,
    this.staticBackground = false,
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
  final bool staticBackground;

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(duration: 300.ms);
    final dragOffset = useState<Offset>(Offset.zero);
    final offsetTween = useRef<Tween<Offset>?>(null);
    final size = MediaQuery.sizeOf(context);

    // Calculate progress of dragging:
    // For vertical – use absolute value of dy,
    // for multi – maximum of relative shifts by X and Y.
    final double progress;
    if (direction == SwipeDismissDirection.vertical) {
      progress = (dragOffset.value.dy.abs() / (size.height / 2)).clamp(0.0, 1.0);
    } else if (direction == SwipeDismissDirection.multi) {
      final progressX = (dragOffset.value.dx.abs() / (size.width / 2)).clamp(0.0, 1.0);
      final progressY = (dragOffset.value.dy.abs() / (size.height / 2)).clamp(0.0, 1.0);
      progress = progressX > progressY ? progressX : progressY;
    } else {
      progress = 0.0;
    }

    final radius = minRadius + (maxRadius - minRadius) * progress;
    final scale = 1.0 - (1.0 - minScale) * progress;
    final opacity = staticBackground ? 1.0 : 1.0 - 0.8 * progress;

    useEffect(
      () {
        void listener() {
          if (offsetTween.value != null) {
            dragOffset.value = offsetTween.value!.evaluate(animationController);
          }
        }

        animationController.addListener(listener);
        return () => animationController.removeListener(listener);
      },
      [animationController],
    );

    // Define the condition for dismissal: for vertical – along the Y axis, for multi – by X or Y.
    final shouldDismiss = useCallback(
      () {
        if (direction == SwipeDismissDirection.vertical) {
          final threshold = size.height * dismissThreshold;
          return dragOffset.value.dy.abs() > threshold;
        } else if (direction == SwipeDismissDirection.multi) {
          final relativeX = dragOffset.value.dx.abs() / size.width;
          final relativeY = dragOffset.value.dy.abs() / size.height;
          return (relativeX > dismissThreshold) || (relativeY > dismissThreshold);
        }
        return false;
      },
      [direction, size, dismissThreshold, dragOffset],
    );

    final handleDragStart = useCallback(
      (_) {
        if (isZoomed) return;
        dragOffset.value = Offset.zero;
      },
      [isZoomed],
    );

    final handleDragUpdate = useCallback(
      (DragUpdateDetails details) {
        if (isZoomed) return;
        if (direction == SwipeDismissDirection.vertical) {
          dragOffset.value += Offset(0, details.delta.dy);
        } else if (direction == SwipeDismissDirection.multi) {
          dragOffset.value += details.delta;
        }
      },
      [isZoomed, direction],
    );

    final handleDragEnd = useCallback(
      (_) {
        if (isZoomed) return;
        if (shouldDismiss()) {
          onDismissed();
        } else {
          offsetTween.value = Tween<Offset>(begin: dragOffset.value, end: Offset.zero);
          animationController
            ..reset()
            ..forward();
        }
      },
      [isZoomed, animationController, onDismissed],
    );

    final content = Transform.translate(
      offset: dragOffset.value,
      child: Transform.scale(
        scale: scale,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: child,
        ),
      ),
    );

    final gestureDetector = GestureDetector(
      onVerticalDragStart:
          direction == SwipeDismissDirection.vertical && !isZoomed ? handleDragStart : null,
      onVerticalDragUpdate:
          direction == SwipeDismissDirection.vertical && !isZoomed ? handleDragUpdate : null,
      onVerticalDragEnd:
          direction == SwipeDismissDirection.vertical && !isZoomed ? handleDragEnd : null,
      onPanStart: direction == SwipeDismissDirection.multi && !isZoomed ? handleDragStart : null,
      onPanUpdate: direction == SwipeDismissDirection.multi && !isZoomed ? handleDragUpdate : null,
      onPanEnd: direction == SwipeDismissDirection.multi && !isZoomed ? handleDragEnd : null,
      behavior: HitTestBehavior.opaque,
      child: content,
    );

    if (staticBackground) {
      return ColoredBox(
        color: backgroundColor,
        child: gestureDetector,
      );
    } else {
      return AnimatedContainer(
        duration: 100.ms,
        color: backgroundColor.withValues(alpha: opacity),
        child: gestureDetector,
      );
    }
  }
}
