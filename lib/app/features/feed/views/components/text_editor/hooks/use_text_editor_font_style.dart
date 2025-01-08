// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/services/logger/logger.dart';

enum FontType { regular, bold, italic, h1, h2, h3, underline }

Set<FontType> useTextEditorFontStyles(QuillController textEditorController) {
  final fontStyles = useState<Set<FontType>>({});

  final textEditorListener = useCallback(
    () {
      final style = textEditorController.getSelectionStyle();
      final activeStyles = <FontType>{};

      Logger.log('style.attributes: ${style.attributes}');

      // Check for header styles (h1, h2, h3)
      if (style.attributes.containsKey(Attribute.header.key)) {
        final headerValue = style.attributes[Attribute.header.key]!.value;
        if (headerValue == 1) {
          activeStyles.add(FontType.h1);
        } else if (headerValue == 2) {
          activeStyles.add(FontType.h2);
        } else if (headerValue == 3) {
          activeStyles.add(FontType.h3);
        }
      } else {
        // If no header is applied, mark it as regular
        activeStyles.add(FontType.regular);
      }

      // Check for bold, italic, and underline styles
      if (style.attributes.containsKey(Attribute.bold.key)) {
        activeStyles.add(FontType.bold);
      }
      if (style.attributes.containsKey(Attribute.italic.key)) {
        activeStyles.add(FontType.italic);
      }
      if (style.attributes.containsKey(Attribute.underline.key)) {
        activeStyles.add(FontType.underline);
      }

      fontStyles.value = activeStyles;
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

  return fontStyles.value;
}
