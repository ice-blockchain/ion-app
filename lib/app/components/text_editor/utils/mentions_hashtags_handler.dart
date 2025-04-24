// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_typing_listener.dart';
import 'package:ion/app/features/feed/providers/article/suggestions_notifier_provider.c.dart';

class MentionsHashtagsHandler extends TextEditorTypingListener {
  MentionsHashtagsHandler({
    required super.controller,
    required super.focusNode,
    required super.context,
    required super.ref,
  });

  @override
  void onTextChanged(
    String text,
    int cursorIndex, {
    required bool isBackspace,
    required bool cursorMoved,
  }) {
    _reapplyAllTags(text);

    final activeTag = _findActiveTagNearCursor(text, cursorIndex);
    if (activeTag == null) {
      ref.invalidate(suggestionsNotifierProvider);
    } else {
      ref
          .read(suggestionsNotifierProvider.notifier)
          .updateSuggestions(activeTag.text, activeTag.tagChar);
    }
  }

  @override
  void onFocusLost() {
    ref.invalidate(suggestionsNotifierProvider);
  }

  void onSuggestionSelected(String suggestion) {
    final fullText = controller.document.toPlainText();
    final cursorIndex = controller.selection.baseOffset;

    final tags = _extractTags(fullText);
    final tag = tags.lastWhere(
      (t) => t.start < cursorIndex && t.start + t.length >= cursorIndex - 1,
      orElse: () => _TagInfo(start: -1, length: 0, text: '', tagChar: ''),
    );

    if (tag.start == -1) return;

    final attribute = _getAttribute(tag.tagChar);

    if (attribute != null) {
      controller.removeListener(editorListener);
      try {
        final suggestionWithTagChar =
            suggestion.startsWith(tag.tagChar) ? suggestion : '${tag.tagChar}$suggestion';
        controller
          ..replaceText(tag.start, tag.length, suggestionWithTagChar, null)
          ..formatText(tag.start, suggestionWithTagChar.length, attribute)
          ..replaceText(tag.start + suggestionWithTagChar.length, 0, ' ', null)
          ..updateSelection(
            TextSelection.collapsed(offset: tag.start + suggestionWithTagChar.length + 1),
            ChangeSource.local,
          );
      } finally {
        controller.addListener(editorListener);
      }

      _reapplyAllTags(controller.document.toPlainText());
      ref.invalidate(suggestionsNotifierProvider);
    }
  }

  void _reapplyAllTags(String fullText) {
    controller.removeListener(editorListener);
    try {
      final tags = _extractTags(fullText);
      _applyTagAttributes(tags);
    } finally {
      controller.addListener(editorListener);
    }
  }

  List<_TagInfo> _extractTags(String text) {
    final regex = RegExp(r'(?:(?<=\s)|^)[@#$]\w+');
    final matches = regex.allMatches(text);

    return matches.map((match) {
      final tagText = match.group(0)!;
      final tagChar = tagText[0];
      return _TagInfo(
        start: match.start,
        length: tagText.length,
        text: tagText,
        tagChar: tagChar,
      );
    }).toList();
  }

  void _applyTagAttributes(List<_TagInfo> tags) {
    final docLength = controller.document.length;

    controller
      ..formatText(0, docLength, const HashtagAttribute.unset())
      ..formatText(0, docLength, const MentionAttribute.unset())
      ..formatText(0, docLength, const CashtagAttribute.unset());

    for (final tag in tags) {
      final attribute = _getAttribute(tag.tagChar);
      if (attribute != null) {
        controller.formatText(tag.start, tag.length, attribute);
      }
    }
  }

  _TagInfo? _findActiveTagNearCursor(String text, int cursorIndex) {
    final tags = _extractTags(text);
    for (final tag in tags) {
      if (cursorIndex > tag.start && cursorIndex <= tag.start + tag.length) {
        return tag;
      }
    }
    return null;
  }

  Attribute<String?>? _getAttribute(String tagChar) {
    return switch (tagChar) {
      '@' => MentionAttribute.withValue(tagChar),
      '#' => HashtagAttribute.withValue(tagChar),
      r'$' => CashtagAttribute.withValue(tagChar),
      _ => null,
    };
  }
}

class _TagInfo {
  _TagInfo({
    required this.start,
    required this.length,
    required this.text,
    required this.tagChar,
  });

  final int start;
  final int length;
  final String text;
  final String tagChar;
}
