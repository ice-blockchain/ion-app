// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<bool> useNodeFocused(FocusNode focusNode) {
  final focused = useState(false);
  useEffect(
    () {
      void onFocusChange() {
        focused.value = focusNode.hasFocus;
      }

      focusNode.addListener(onFocusChange);
      return () => focusNode.removeListener(onFocusChange);
    },
    [focusNode],
  );
  return focused;
}
