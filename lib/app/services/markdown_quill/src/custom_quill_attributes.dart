import 'package:flutter_quill/flutter_quill.dart';

/// Custom attribute to save the language of codeblock
class CodeBlockLanguageAttribute extends Attribute<String?> {
  /// attribute key
  static const attrKey = 'x-md-codeblock-lang';

  /// @nodoc
  CodeBlockLanguageAttribute(String? value)
      : super(attrKey, AttributeScope.ignore, value);
}
