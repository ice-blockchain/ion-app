import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useTextChanged({
  TextEditingController? controller,
  required Function(String)? onTextChanged,
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
    <Object?>[onTextChanged, controller],
  );
}
