import 'package:flutter_hooks/flutter_hooks.dart';

enum FontType { regular, bold, italic }

class FontTypeState {
  FontType fontType;
  void Function(FontType) setFontType;

  FontTypeState(this.fontType, this.setFontType);
}

FontTypeState useFontType() {
  final fontType = useState<FontType>(FontType.regular);

  void setFontType(FontType type) {
    fontType.value = type;
  }

  return FontTypeState(fontType.value, setFontType);
}
