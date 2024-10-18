// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/services/logger/logger.dart';

enum FontType { regular, bold, italic, h1, h2, h3 }

FontType useTextEditorFontStyle(QuillController textEditorController) {
  final fontType = useState<FontType>(FontType.regular);

  final textEditorListener = useCallback(
    () {
      final style = textEditorController.getSelectionStyle();

      Logger.log('style attributes: ${style.attributes}');
      Logger.log('Previous fontType: ${fontType.value}');

      if (style.attributes.containsKey(Attribute.header.key)) {
        final headerValue = style.attributes[Attribute.header.key]!.value;

        if (headerValue == 1) {
          fontType.value = FontType.h1;
          Logger.log('Detected h1 style, updating fontType to h1');
        } else if (headerValue == 2) {
          fontType.value = FontType.h2;
          Logger.log('Detected h2 style, updating fontType to h2');
        } else if (headerValue == 3) {
          fontType.value = FontType.h3;
          Logger.log('Detected h3 style, updating fontType to h3');
        }
      } else if (style.attributes.containsKey(Attribute.bold.key)) {
        fontType.value = FontType.bold;
        Logger.log('Detected bold style, updating fontType to bold');
      } else if (style.attributes.containsKey(Attribute.italic.key)) {
        fontType.value = FontType.italic;
        Logger.log('Detected italic style, updating fontType to italic');
      } else {
        fontType.value = FontType.regular;
        Logger.log('No specific styles detected, updating fontType to regular');
      }

      Logger.log('New fontType: ${fontType.value}');
    },
    [textEditorController],
  );

  useEffect(
    () {
      textEditorController.addListener(textEditorListener);
      Logger.log('Listener added to QuillController');
      return () {
        Logger.log('Listener removed from QuillController');
        textEditorController.removeListener(textEditorListener);
      };
    },
    [textEditorListener, textEditorController],
  );

  return fontType.value;
}
