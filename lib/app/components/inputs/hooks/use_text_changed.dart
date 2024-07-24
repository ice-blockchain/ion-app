import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useTextChanged({
  required void Function(String)? onTextChanged,
  TextEditingController? controller,
}) {
  useEffect(
    () {
      if (controller != null && onTextChanged != null) {
        void onControllerChange() {
          onTextChanged(controller.text);
        }

        controller.addListener(onControllerChange);
        return () => controller.removeListener(onControllerChange);
      }
      return null;
    },
    [onTextChanged, controller],
  );
}
