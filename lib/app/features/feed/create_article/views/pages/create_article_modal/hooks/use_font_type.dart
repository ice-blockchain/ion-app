import 'package:flutter_hooks/flutter_hooks.dart';

enum FontType { regular, bold, italic }

(FontType, void Function(FontType type)) useFontType() {
  final fontType = useState<FontType>(FontType.regular);

  void setFontType(FontType type) {
    fontType.value = type;
  }

  return (fontType.value, setFontType);
}
