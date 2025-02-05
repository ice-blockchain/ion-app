// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/article/suggestions_notifier_provider.c.dart';
import 'package:ion/app/features/feed/views/components/text_editor/attributes.dart';

const maxMentionsLength = 3;
const maxHashtagsLength = 5;

class MentionsHashtagsHandler {
  MentionsHashtagsHandler({
    required this.controller,
    required this.focusNode,
    required this.context,
    required this.ref,
  });

  final QuillController controller;
  final FocusNode focusNode;
  final BuildContext context;
  final WidgetRef ref;
  String taggingCharacter = '';
  int lastTagIndex = -1;
  Timer? _debounce;
  String? previousText;

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
    final isBackspace = previousText != null && text.length < previousText!.length;

    if (previousText == text) return;

    previousText = text;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1), () {
      if (cursorIndex > 0) {
        final char = text.substring(cursorIndex - 1, cursorIndex);

        if (char == '#' || char == '@' || char == r'$') {
          taggingCharacter = char;
          lastTagIndex = cursorIndex - 1;

          controller.removeListener(_editorListener);
          try {
            final attribute = switch (taggingCharacter) {
              '@' => MentionAttribute.withValue(taggingCharacter),
              '#' => HashtagAttribute.withValue(taggingCharacter),
              r'$' => CashtagAttribute.withValue(taggingCharacter),
              _ => null,
            };
            if (attribute != null) {
              controller.formatText(lastTagIndex, 1, attribute);
            }
          } finally {
            controller.addListener(_editorListener);
          }
          ref
              .read(suggestionsNotifierProvider.notifier)
              .updateSuggestions(taggingCharacter, taggingCharacter);
        } else if (char == ' ' || char == '\n') {
          _applyTagIfNeeded(cursorIndex);
          ref.read(suggestionsNotifierProvider.notifier).clear();
        } else if (lastTagIndex != -1) {
          final currentTagText = text.substring(lastTagIndex, cursorIndex);
          ref
              .read(suggestionsNotifierProvider.notifier)
              .updateSuggestions(currentTagText, taggingCharacter);

          if (lastTagIndex >= 0 && cursorIndex > lastTagIndex) {
            controller.removeListener(_editorListener);
            try {
              final attribute = switch (taggingCharacter) {
                '@' => MentionAttribute.withValue(currentTagText),
                '#' => HashtagAttribute.withValue(currentTagText),
                r'$' => CashtagAttribute.withValue(currentTagText),
                _ => null,
              };
              if (attribute != null) {
                controller.formatText(lastTagIndex, cursorIndex - lastTagIndex, attribute);
              }
            } finally {
              controller.addListener(_editorListener);
            }
          }
        }
      }

      if (isBackspace && lastTagIndex != -1) {
        final remainingText = text.substring(lastTagIndex, cursorIndex);
        if (remainingText == '#' || remainingText == '@' || remainingText == r'$') {
          lastTagIndex = -1;
          lastTagIndex = cursorIndex - 1;
          ref.read(suggestionsNotifierProvider.notifier).updateSuggestions('', taggingCharacter);
        }
      }
    });
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
        ..removeListener(_editorListener)
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

      lastTagIndex = -1;
      taggingCharacter = '';
    } finally {
      controller.addListener(_editorListener);
    }
    ref.read(suggestionsNotifierProvider.notifier).clear();
  }

  void _applyTagIfNeeded(int cursorIndex) {
    if (lastTagIndex == -1) return;

    final tagText = controller.document.toPlainText().substring(lastTagIndex, cursorIndex);
    final attribute = switch (taggingCharacter) {
      '@' => MentionAttribute.withValue(tagText),
      '#' => HashtagAttribute.withValue(tagText),
      r'$' => CashtagAttribute.withValue(tagText),
      _ => null,
    };

    if (attribute != null) {
      controller.formatText(lastTagIndex, tagText.length, attribute);
    }

    lastTagIndex = -1;
    taggingCharacter = '';
  }

  void _focusListener() {
    if (!focusNode.hasFocus) {
      ref.read(suggestionsNotifierProvider.notifier).clear();
    }
  }
}
