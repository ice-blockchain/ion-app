// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

enum FontType { regular, bold, italic, h1, h2, h3, underline }

FontType useTextEditorFontStyle(QuillController textEditorController) {
  final fontType = useState<FontType>(FontType.regular);

  final textEditorListener = useCallback(
    () {
      final style = textEditorController.getSelectionStyle();

      if (style.attributes.containsKey(Attribute.header.key)) {
        final headerValue = style.attributes[Attribute.header.key]!.value;

        if (headerValue == 1) {
          fontType.value = FontType.h1;
        } else if (headerValue == 2) {
          fontType.value = FontType.h2;
        } else if (headerValue == 3) {
          fontType.value = FontType.h3;
        }
      } else if (style.attributes.containsKey(Attribute.bold.key)) {
        fontType.value = FontType.bold;
      } else if (style.attributes.containsKey(Attribute.italic.key)) {
        fontType.value = FontType.italic;
      } else if (style.attributes.containsKey(Attribute.underline.key)) {
        fontType.value = FontType.underline;
      } else {
        fontType.value = FontType.regular;
      }
    },
    [textEditorController],
  );

  useEffect(
    () {
      textEditorController.addListener(textEditorListener);
      return () {
        textEditorController.removeListener(textEditorListener);
      };
    },
    [textEditorListener, textEditorController],
  );

  return fontType.value;
}
