// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';

/// Returns a function that hides keyboard and ignores subsequent calls
/// during hiding.
///
/// Useful for button handlers when users may press it multiple times
/// in short succession.
void Function({VoidCallback? callback}) useHideKeyboardAndCallOnce() {
  final context = useContext();
  final isInProgress = useRef(false);

  return ({VoidCallback? callback}) {
    if (!isInProgress.value) {
      isInProgress.value = true;
      hideKeyboard(
        context,
        callback: () {
          if (context.mounted) {
            callback?.call();
          }
          isInProgress.value = false;
        },
      );
    }
  };
}
