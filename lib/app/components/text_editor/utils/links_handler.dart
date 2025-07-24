// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_typing_listener.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

class LinksHandler extends TextEditorTypingListener {
  LinksHandler({
    required super.controller,
    required super.focusNode,
    required super.context,
    required super.ref,
  });

  final _urlMatcher = const UrlMatcher();
  bool _isFormatting = false;
  Timer? _debounceTimer;

  @override
  void onTextChanged(
    String text,
    int cursorIndex, {
    required bool isBackspace,
    required bool cursorMoved,
  }) {
    if (_isFormatting) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      _formatLinks(text);
    });
  }

  @override
  void onFocusLost() {
    if (_isFormatting) return;
    _formatLinks(controller.document.toPlainText());
  }

  void _formatLinks(String text) {
    _isFormatting = true;
    // Remove only existing link attributes
    final deltaOps = controller.document.toDelta().toList();
    var offset = 0;
    for (final op in deltaOps) {
      final attrs = op.attributes;
      final len = op.data is String ? (op.data! as String).length : 1;
      if (attrs != null && attrs.containsKey(Attribute.link.key)) {
        // Unset link attribute without affecting other attributes
        controller.formatText(
          offset,
          len,
          Attribute.clone(Attribute.link, null),
        );
      }
      offset += len;
    }

    final matches = RegExp(_urlMatcher.pattern).allMatches(text);
    for (final match in matches) {
      final url = match.group(0);
      if (url == null) continue;
      controller.formatText(match.start, match.end - match.start, LinkAttribute(url));
    }
    _isFormatting = false;
  }
}
