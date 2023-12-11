import 'package:flutter/foundation.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class KeyboardService {
  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  final ValueNotifier<bool> isKeyboardVisible = ValueNotifier<bool>(false);

  void init() {
    keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible.value = visible;
    });
  }

  void dispose() {
    isKeyboardVisible.dispose();
  }
}
