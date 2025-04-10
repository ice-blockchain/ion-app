// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

bool useTextEditorHasContent(QuillController textEditorController) {
  final hasContent = useState<bool>(_checkContentNotEmpty(textEditorController));

  useEffect(
    () {
      void textEditorListener() {
        hasContent.value = _checkContentNotEmpty(textEditorController);
      }

      textEditorController.addListener(textEditorListener);
      return () {
        textEditorController.removeListener(textEditorListener);
      };
    },
    [],
  );

  return hasContent.value;
}

bool _checkContentNotEmpty(QuillController controller) {
  if (controller.document.isEmpty()) {
    return false;
  }

  final plainText = controller.document.toPlainText().trim();
  return plainText.isNotEmpty && plainText != '\n';
}
