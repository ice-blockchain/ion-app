import 'package:flutter/material.dart';
import 'package:ice/app/services/keyboard_service.dart';

class InputFieldController {
  InputFieldController({
    FocusNode? focusNode,
    this.enabled = true,
    required this.widgetKey,
    this.scrollToOnFocusKey,
  }) : focusNode = focusNode ?? FocusNode();

  final FocusNode focusNode;
  final bool enabled;
  final GlobalKey widgetKey;
  final GlobalKey? scrollToOnFocusKey;

  double scrollPadding = 0.0;

  InputFieldState get _state {
    if (!enabled) {
      return InputFieldState.disabled;
    } else if (focusNode.hasFocus) {
      return InputFieldState.focused;
    } else {
      return InputFieldState.enabled;
    }
  }

  void _updateState() {
    state = _state;
  }

  InputFieldState state = InputFieldState.enabled;

  void onInit() {
    focusNode.addListener(_updateState);

    if (scrollToOnFocusKey != null) {
      final KeyboardService keyboardController = KeyboardService();

      keyboardController.isKeyboardVisible.addListener(() async {
        if (keyboardController.isKeyboardVisible.value) {
          await Future<void>.delayed(const Duration(milliseconds: 50));

          final RenderBox? box1 =
              widgetKey.currentContext?.findRenderObject() as RenderBox?;
          final RenderBox? box2 = scrollToOnFocusKey!.currentContext
              ?.findRenderObject() as RenderBox?;

          if (box1 != null && box2 != null) {
            final double distance = _getYPosition(box1) - _getYPosition(box2);

            if (distance > 0) {
              scrollPadding = distance;
            }
          }
        }
      });
    }
  }

  static double _getYPosition(RenderBox box) =>
      box.globalToLocal(Offset.zero).dy - box.size.height;
}

enum InputFieldState {
  enabled,
  disabled,
  focused,
}
