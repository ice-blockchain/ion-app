import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';

enum FontType { regular, bold, italic }

FontType useTextEditorFontStyle(QuillController textEditorController) {
  final fontType = useState<FontType>(FontType.regular);

  final textEditorListener = useCallback(
    () {
      final style = textEditorController.getSelectionStyle();

      if (style.attributes.containsKey(Attribute.bold.key)) {
        fontType.value = FontType.bold;
      } else if (style.attributes.containsKey(Attribute.italic.key)) {
        fontType.value = FontType.italic;
      } else {
        fontType.value = FontType.regular;
      }
    },
    [],
  );

  useEffect(
    () {
      textEditorController.addListener(textEditorListener);
      return () {
        textEditorController.removeListener(textEditorListener);
      };
    },
    [],
  );

  return fontType.value;
}
