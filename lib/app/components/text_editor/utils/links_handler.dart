// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_typing_listener.dart';
import 'package:ion/app/services/text_parser/data/models/text_matcher.dart';

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
    final matches = RegExp(_urlMatcher.pattern).allMatches(text);
    final doc = controller.document;
    for (final match in matches) {
      final url = match.group(0);
      if (url == null) continue;
      final attrs = doc.collectStyle(match.start, match.end - match.start).attributes;
      final isAlreadyLink =
          attrs.containsKey(Attribute.link.key) && attrs[Attribute.link.key]?.value == url;
      if (!isAlreadyLink) {
        controller.formatText(match.start, match.end - match.start, LinkAttribute(url));
      }
    }
    _isFormatting = false;
  }
}
