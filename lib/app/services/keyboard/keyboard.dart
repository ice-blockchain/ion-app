import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

Future<void> hideKeyboardAndCall(
  BuildContext context, {
  required void Function() callback,
}) async {
  if (KeyboardVisibilityProvider.isKeyboardVisible(context)) {
    FocusManager.instance.primaryFocus?.unfocus();
    await Future<void>.delayed(
      const Duration(seconds: 1),
    );
    if (context.mounted) {
      callback();
    }
  } else {
    callback();
  }
}
