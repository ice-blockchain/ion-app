import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

(double, void Function(DragUpdateDetails), void Function(DragEndDetails)) useVerticalDragOffset(
  BuildContext context,
) {
  final offsetY = useState<double>(0);
  final screenHeight = MediaQuery.sizeOf(context).height;

  void handleDragUpdate(DragUpdateDetails details) {
    final newOffset = offsetY.value + details.delta.dy;
    offsetY.value = newOffset.clamp(0.0, screenHeight);
  }

  void handleDragEnd(DragEndDetails details) {
    if (offsetY.value > screenHeight / 2) {
      context.pop();
    } else {
      offsetY.value = 0.0;
    }
  }

  return (
    offsetY.value,
    handleDragUpdate,
    handleDragEnd,
  );
}
