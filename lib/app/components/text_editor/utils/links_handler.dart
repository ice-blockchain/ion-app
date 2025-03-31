import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

class LinksHandler {
  LinksHandler({
    required this.controller,
    required this.focusNode,
    required this.context,
    required this.ref,
  });

  final QuillController controller;
  final FocusNode focusNode;
  final BuildContext context;
  final WidgetRef ref;
  Timer? _debounce;
  String? previousText;
  final _urlMatcher = const UrlMatcher();

  void initialize() {
    controller.addListener(_editorListener);
    focusNode.addListener(_focusListener);
  }

  void dispose() {
    controller.removeListener(_editorListener);
    focusNode.removeListener(_focusListener);
    _debounce?.cancel();
  }

  void _editorListener() {
    final cursorIndex = controller.selection.baseOffset;
    final text = controller.document.toPlainText();

    previousText = text;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1), () {
      _cleanAndReformatLinks(text);

      if (cursorIndex > 0) {
        final char = text.substring(cursorIndex - 1, cursorIndex);
        if (_isWordBoundary(char)) {
          _checkAndFormatLink(text, cursorIndex);
        }
      }
    });
  }

  void _cleanAndReformatLinks(String text) {
    controller.removeListener(_editorListener);

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
      controller.addListener(_editorListener);
    }
  }

  void _checkAndFormatLink(String text, int cursorIndex) {
    final matches = RegExp(_urlMatcher.pattern).allMatches(text);
    for (final match in matches) {
      if (match.end == cursorIndex) {
        final url = match.group(0);
        if (url != null) {
          controller.removeListener(_editorListener);
          try {
            controller.formatText(
              match.start,
              match.end - match.start,
              LinkAttribute(url),
            );
          } finally {
            controller.addListener(_editorListener);
          }
        }
        break;
      }
    }
  }

  bool _isWordBoundary(String char) {
    return char == ' ' || char == '\n' || _isPunctuation(char);
  }

  bool _isPunctuation(String char) {
    const regularPunctuation = '.,;:!?()[]{}"\'\\/\\`~=+<>*&^%_-|';
    const specialQuotes = '\u2018\u2019\u201C\u201D\u2032\u2035\u00B4\u0060\u00AB\u00BB';
    return regularPunctuation.contains(char) || specialQuotes.contains(char);
  }

  void _focusListener() {
    if (!focusNode.hasFocus) {
      _cleanAndReformatLinks(controller.document.toPlainText());
    }
  }

  void triggerListener() {
    _editorListener();
  }
}
