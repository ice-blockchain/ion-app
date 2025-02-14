// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/flutter_quill.dart';

/// Custom attribute to save the language of codeblock
class CodeBlockLanguageAttribute extends Attribute<String?> {
  /// @nodoc
  const CodeBlockLanguageAttribute(String? value) : super(attrKey, AttributeScope.ignore, value);

  /// attribute key
  static const attrKey = 'x-md-codeblock-lang';
}
