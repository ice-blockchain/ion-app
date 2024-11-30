import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

/// A hook that enables page dismissal with vertical drag gesture.
///
/// This hook provides:
/// - Vertical drag gesture handling
/// - Smooth animation when dismissing or returning the page to initial position
/// - Automatic page pop when drag reaches threshold
///
/// Example usage:
/// ```dart
/// final dismiss = usePageDismiss(context);
///
/// return GestureDetector(
///   onVerticalDragUpdate: dismiss.onDragUpdate,
///   onVerticalDragEnd: dismiss.onDragEnd,
///   child: Transform.translate(
///     offset: Offset(0, dismiss.offset),
///     child: child,
///   ),
/// );
/// ```
///
/// The page will be dismissed when:
/// - The drag offset exceeds half of the screen height
/// - The drag velocity is greater than 300 logical pixels per second
///
({
  double offset,
  void Function(DragUpdateDetails) onDragUpdate,
  void Function(DragEndDetails) onDragEnd,
}) usePageDismiss(
  BuildContext context, {
  Duration animationDuration = const Duration(milliseconds: 300),
  Curve animationCurve = Curves.easeOut,
}) {
  final screenHeight = MediaQuery.sizeOf(context).height;

  final offsetY = useState<double>(0);
  final animationController = useAnimationController(duration: animationDuration);

  final startAnimation = useCallback(
    (double endValue) {
      final startValue = offsetY.value;
      animationController.value = startValue / screenHeight;
      final tween = Tween(begin: startValue, end: endValue);

      void animate() {
        offsetY.value = tween.evaluate(
          CurvedAnimation(
            parent: animationController,
            curve: animationCurve,
          ),
        );
      }

      animationController.addListener(animate);
      animationController.forward().whenComplete(() {
        animationController
          ..removeListener(animate)
          ..reset();
      });
    },
    [screenHeight],
  );

  final onDragUpdate = useCallback(
    (DragUpdateDetails details) {
      offsetY.value = (offsetY.value + details.delta.dy).clamp(0.0, screenHeight);
    },
    [screenHeight],
  );

  final onDragEnd = useCallback(
    (DragEndDetails details) {
      final velocity = details.primaryVelocity ?? 0;
      final shouldDismiss = velocity > 300 || offsetY.value > screenHeight / 2;

      startAnimation(shouldDismiss ? screenHeight : 0);
    },
    [screenHeight],
  );

  useEffect(
    () {
      if (offsetY.value >= screenHeight) {
        context.pop();
      }
      return null;
    },
    [offsetY.value],
  );

  return (
    offset: offsetY.value,
    onDragUpdate: onDragUpdate,
    onDragEnd: onDragEnd,
  );
}
