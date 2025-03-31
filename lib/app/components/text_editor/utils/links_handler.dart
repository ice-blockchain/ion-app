// SPDX-License-Identifier: ice License 1.0

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

  @override
  void onTextChanged(String text, int cursorIndex, bool isBackspace, bool cursorMoved) {
    _cleanAndReformatLinks(text);

    if (cursorIndex > 0) {
      final char = text.substring(cursorIndex - 1, cursorIndex);
      if (isWordBoundary(char)) {
        _checkAndFormatLink(text, cursorIndex);
      }
    }
  }

  @override
  void onFocusLost() {
    _cleanAndReformatLinks(controller.document.toPlainText());
  }

  void _cleanAndReformatLinks(String text) {
    controller.removeListener(editorListener);

    try {
      final matches = RegExp(_urlMatcher.pattern).allMatches(text);
      for (final match in matches) {
        final url = match.group(0);
        if (url != null) {
          controller.formatText(
            match.start,
            match.end - match.start,
            LinkAttribute(url),
          );
        }
      }
    } finally {
      controller.addListener(editorListener);
    }
  }

  void _checkAndFormatLink(String text, int cursorIndex) {
    final matches = RegExp(_urlMatcher.pattern).allMatches(text);
    for (final match in matches) {
      if (match.end == cursorIndex) {
        final url = match.group(0);
        if (url != null) {
          controller.removeListener(editorListener);
          try {
            controller.formatText(
              match.start,
              match.end - match.start,
              LinkAttribute(url),
            );
          } finally {
            controller.addListener(editorListener);
          }
        }
        break;
      }
    }
  }
}
