import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

ValueNotifier<bool> useNodeFocused(FocusNode focusNode) {
  final ValueNotifier<bool> focused = useState(false);
  useEffect(
    () {
      void onFocusChange() {
        focused.value = focusNode.hasFocus;
      }

      focusNode.addListener(onFocusChange);
      return () => focusNode.removeListener(onFocusChange);
    },
    <Object?>[focusNode],
  );
  return focused;
}
