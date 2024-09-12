import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

void useGoBackOnBlur({required FocusNode focusNode, bool enabled = true}) {
  final context = useContext();
  useEffect(
    () {
      if (enabled) {
        void onFocusChange() {
          if (!focusNode.hasFocus) {
            context.pop();
          }
        }

        focusNode.addListener(onFocusChange);
        return () => focusNode.removeListener(onFocusChange);
      }
      return null;
    },
    [focusNode, enabled],
  );
}
