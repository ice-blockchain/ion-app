// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

int useTextEditorCharacterLimitExceedAmount(
  QuillController textEditorController,
  int maxCharacters,
) {
  // Quill document's initial length is 1: https://github.com/singerdmx/flutter-quill/issues/2047
  final documentLength = textEditorController.document.length - 1;
  final exceedAmount = useState(documentLength - maxCharacters);

  useEffect(
    () {
      void textEditorListener() {
        final documentLength = textEditorController.document.length - 1;
        exceedAmount.value = documentLength - maxCharacters;
      }

      textEditorController.addListener(textEditorListener);
      return () => textEditorController.removeListener(textEditorListener);
    },
    [textEditorController],
  );

  return exceedAmount.value;
}
