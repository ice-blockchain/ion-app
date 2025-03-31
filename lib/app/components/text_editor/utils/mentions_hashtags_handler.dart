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

  String taggingCharacter = '';
  int lastTagIndex = -1;

  @override
  void onTextChanged(
    String text,
    int cursorIndex, {
    required bool isBackspace,
    required bool cursorMoved,
  }) {
    if (cursorMoved) {
      _cleanAndReformatTags(text);
    }

    if (cursorIndex > 0) {
      final char = text.substring(cursorIndex - 1, cursorIndex);

      if (char == '#' || char == '@' || char == r'$') {
        taggingCharacter = char;
        lastTagIndex = cursorIndex - 1;

        _formatSingleWord(text, lastTagIndex);

        ref.invalidate(suggestionsNotifierProvider);
      } else if (char == ' ' || char == '\n') {
        if (lastTagIndex != -1) {
          _resetState();
          ref.invalidate(suggestionsNotifierProvider);
        }
      } else if (lastTagIndex != -1) {
        final currentText = text.substring(lastTagIndex, cursorIndex);
        final spaceIndex = currentText.indexOf(' ');

        if (spaceIndex != -1) {
          final tagText = currentText.substring(0, spaceIndex);
          _applyFormatting(lastTagIndex, spaceIndex, tagText);
          _resetState();
        } else {
          _applyFormatting(lastTagIndex, cursorIndex - lastTagIndex, currentText);
        }
      }
    }

    if (isBackspace && lastTagIndex != -1) {
      if (cursorIndex <= lastTagIndex) {
        _resetState();
        ref.invalidate(suggestionsNotifierProvider);
      } else {
        final remainingText = text.substring(lastTagIndex, cursorIndex);
        if (remainingText.isNotEmpty) {
          final spaceIndex = remainingText.indexOf(' ');
          if (spaceIndex != -1) {
            _applyFormatting(lastTagIndex, spaceIndex, remainingText.substring(0, spaceIndex));
            _resetState();
          } else {
            _applyFormatting(lastTagIndex, remainingText.length, remainingText);
          }
        }
      }
    }
  }

  @override
  void onFocusLost() {
    ref.invalidate(suggestionsNotifierProvider);
  }

  void _cleanAndReformatTags(String text) {
    controller.removeListener(editorListener);

    try {
      final tags = <_TagInfo>[];

      for (var i = 0; i < text.length; i++) {
        if ((text[i] == '#' || text[i] == '@' || text[i] == r'$') && _isWordStart(text, i)) {
          var endIndex = i;
          for (var j = i + 1; j < text.length; j++) {
            if (isWordBoundary(text[j])) {
              break;
            }
            endIndex = j;
          }

          if (endIndex >= i) {
            final tagText = text.substring(i, endIndex + 1);
            if (tagText.length > 1) {
              tags.add(
                _TagInfo(
                  start: i,
                  length: tagText.length,
                  text: tagText,
                  tagChar: text[i],
                ),
              );
            }
          }
        }
      }

      for (final tag in tags) {
        final attribute = switch (tag.tagChar) {
          '#' => HashtagAttribute.withValue(tag.text),
          '@' => MentionAttribute.withValue(tag.text),
          r'$' => CashtagAttribute.withValue(tag.text),
          _ => null,
        };

        if (attribute != null) {
          controller.formatText(tag.start, tag.length, attribute);
        }
      }
    } finally {
      controller.addListener(editorListener);
    }
  }

  void _formatSingleWord(String text, int tagIndex) {
    if (tagIndex >= 0 && tagIndex < text.length) {
      final tagChar = text[tagIndex];
      if (tagChar == '#' || tagChar == r'$') {
        final tagAttribute = switch (tagChar) {
          '#' => const HashtagAttribute.withValue('#'),
          r'$' => const CashtagAttribute.withValue(r'$'),
          _ => null,
        };

        if (tagAttribute != null) {
          controller.removeListener(editorListener);
          try {
            controller.formatText(tagIndex, 1, tagAttribute);
          } finally {
            controller.addListener(editorListener);
          }
        }

        if (tagIndex + 1 < text.length) {
          var endIndex = tagIndex;
          for (var i = tagIndex + 1; i < text.length; i++) {
            if (isWordBoundary(text[i])) {
              break;
            }
            endIndex = i;
          }

          if (endIndex > tagIndex) {
            final wordLength = endIndex - tagIndex + 1;
            final tagText = text.substring(tagIndex, tagIndex + wordLength);

            final attribute = switch (tagChar) {
              '#' => HashtagAttribute.withValue(tagText),
              r'$' => CashtagAttribute.withValue(tagText),
              _ => null,
            };

            if (attribute != null) {
              controller.removeListener(editorListener);
              try {
                controller.formatText(tagIndex, wordLength, attribute);
              } finally {
                controller.addListener(editorListener);
              }
            }
          }
        }
      }
    }
  }

  bool _isWordStart(String text, int index) {
    if (index == 0) return true;
    final prevChar = text[index - 1];
    return isWordBoundary(prevChar);
  }

  void _applyFormatting(int index, int length, String text) {
    var actualLength = length;
    var actualText = text;

    for (var i = 0; i < text.length; i++) {
      if (isPunctuation(text[i])) {
        actualLength = i;
        actualText = text.substring(0, i);
        break;
      }
    }

    if (actualLength == 0) {
      return;
    }

    controller.removeListener(editorListener);
    try {
      final attribute = switch (taggingCharacter) {
        '@' => MentionAttribute.withValue(actualText),
        '#' => HashtagAttribute.withValue(actualText),
        r'$' => CashtagAttribute.withValue(actualText),
        _ => null,
      };
      if (attribute != null) {
        controller.formatText(index, actualLength, attribute);
      }
    } finally {
      controller.addListener(editorListener);
    }
  }

  void onSuggestionSelected(String suggestion) {
    final cursorIndex = controller.selection.baseOffset;

    final attribute = switch (taggingCharacter) {
      '@' => MentionAttribute.withValue(suggestion),
      '#' => HashtagAttribute.withValue(suggestion),
      r'$' => CashtagAttribute.withValue(suggestion),
      _ => null,
    };

    try {
      controller
        ..removeListener(editorListener)
        ..replaceText(
          lastTagIndex,
          cursorIndex - lastTagIndex,
          suggestion,
          null,
        )
        ..formatText(lastTagIndex, suggestion.length, attribute)
        ..replaceText(
          lastTagIndex + suggestion.length,
          0,
          ' ',
          null,
        );

      final newCursorIndex = lastTagIndex + suggestion.length + 1;

      controller.updateSelection(
        TextSelection.collapsed(offset: newCursorIndex),
        ChangeSource.local,
      );

      _resetState();
    } finally {
      controller.addListener(editorListener);
    }
    ref.invalidate(suggestionsNotifierProvider);
  }

  void _resetState() {
    lastTagIndex = -1;
    taggingCharacter = '';
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
