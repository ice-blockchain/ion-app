// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

int useTextEditorCharacterLimitExceedAmount(
  QuillController textEditorController,
  int maxCharacters,
) {
  final exceedAmount = useState(textEditorController.document.length - maxCharacters);

  useEffect(
    () {
      void textEditorListener() {
        exceedAmount.value = textEditorController.document.length - maxCharacters;
      }

      textEditorController.addListener(textEditorListener);
      return () => textEditorController.removeListener(textEditorListener);
    },
    [textEditorController],
  );

  return exceedAmount.value;
}
