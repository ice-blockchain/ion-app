// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

bool useTextEditorHasContent(QuillController textEditorController) {
  final hasContent = useState<bool>(!textEditorController.document.isEmpty());

  useEffect(
    () {
      void textEditorListener() {
        hasContent.value = !textEditorController.document.isEmpty();
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
