// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/article/suggestions_notifier_provider.c.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/hashtags_suggestions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/mentions_suggestions.dart';

const maxMentionsLength = 3;
const maxHashtagsLength = 5;

class MentionAttribute extends Attribute<String> {
  const MentionAttribute(String mentionValue)
      : super('mention', AttributeScope.inline, mentionValue);

  const MentionAttribute.withValue(String value) : this(value);
}

class HashtagAttribute extends Attribute<String> {
  const HashtagAttribute(String hashtagValue)
      : super('hashtag', AttributeScope.inline, hashtagValue);

  const HashtagAttribute.withValue(String value) : this(value);
}

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
  OverlayEntry? overlayEntry;
  String taggingCharacter = '';
  int lastTagIndex = -1;
  bool isLinkApplied = false;
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
    removeOverlay();
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

        if (char == '#' || char == '@') {
          taggingCharacter = char;
          lastTagIndex = cursorIndex - 1;

          controller.removeListener(_editorListener);
          try {
            final attribute = taggingCharacter == '@'
                ? MentionAttribute.withValue(taggingCharacter)
                : HashtagAttribute.withValue(taggingCharacter);
            controller.formatText(lastTagIndex, 1, attribute);
          } finally {
            controller.addListener(_editorListener);
          }
          // showOverlay();
        } else if (char == ' ' || char == '\n') {
          _applyTagIfNeeded(cursorIndex);
          removeOverlay();
        } else if (lastTagIndex != -1) {
          final currentTagText = text.substring(lastTagIndex, cursorIndex);
          ref
              .read(suggestionsNotifierProvider.notifier)
              .updateSuggestions(currentTagText, taggingCharacter);

          if (lastTagIndex >= 0 && cursorIndex > lastTagIndex) {
            controller.removeListener(_editorListener);
            try {
              final attribute = taggingCharacter == '@'
                  ? MentionAttribute.withValue(currentTagText)
                  : HashtagAttribute.withValue(currentTagText);
              controller.formatText(lastTagIndex, cursorIndex - lastTagIndex, attribute);
            } finally {
              controller.addListener(_editorListener);
            }
          }
        }
      }

      if (isBackspace && lastTagIndex != -1) {
        final remainingText = text.substring(lastTagIndex, cursorIndex);
        if (remainingText == '#' || remainingText == '@') {
          lastTagIndex = -1;
          lastTagIndex = cursorIndex - 1;
          ref.read(suggestionsNotifierProvider.notifier).updateSuggestions('', taggingCharacter);
        }
      }
    });
  }

  void _onSuggestionSelected(String suggestion) {
    final cursorIndex = controller.selection.baseOffset;
    final attribute = taggingCharacter == '@'
        ? MentionAttribute.withValue(suggestion)
        : HashtagAttribute.withValue(suggestion);

    try {
      controller
        ..removeListener(_editorListener)
        ..replaceText(
          lastTagIndex,
          cursorIndex - lastTagIndex,
          '$suggestion ',
          null,
        )
        ..formatText(lastTagIndex, suggestion.length, attribute);

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

    removeOverlay();
  }

  void _applyTagIfNeeded(int cursorIndex) {
    if (overlayEntry != null && lastTagIndex != -1) {
      final tagText = controller.document.toPlainText().substring(lastTagIndex, cursorIndex);
      final attribute = taggingCharacter == '@'
          ? MentionAttribute.withValue(tagText)
          : HashtagAttribute.withValue(tagText);

      if (lastTagIndex >= 0 && cursorIndex > lastTagIndex) {
        try {
          controller
            ..replaceText(lastTagIndex, cursorIndex - lastTagIndex, tagText, null)
            ..formatText(lastTagIndex, tagText.length, attribute);
        } finally {
          lastTagIndex = -1;
          isLinkApplied = false;
        }
      }
    }
  }

  void _focusListener() {
    if (!focusNode.hasFocus) removeOverlay();
  }

  void showOverlay() {
    removeOverlay();
    overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final suggestions = ref.read(suggestionsNotifierProvider);
    final itemsLength = taggingCharacter == '@'
        ? (suggestions.length > maxMentionsLength ? maxMentionsLength : suggestions.length)
        : (suggestions.length > maxHashtagsLength ? maxHashtagsLength : suggestions.length);
    final itemSize = taggingCharacter == '@' ? mentionItemSize : hashtagItemSize;
    final containerPadding =
        taggingCharacter == '@' ? mentionContainerPadding : hashtagContainerPadding;

    final totalSuggestionHeight = itemsLength * itemSize + containerPadding * 2;
    final topPosition = screenHeight - keyboardHeight - totalSuggestionHeight - toolbarHeight;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: topPosition,
        right: 0,
        child: SizedBox(
          height: totalSuggestionHeight,
          child: taggingCharacter == '@'
              ? MentionsSuggestions(
                  suggestions: suggestions,
                  onSuggestionSelected: _onSuggestionSelected,
                )
              : HashtagsSuggestions(
                  suggestions: suggestions,
                  onSuggestionSelected: _onSuggestionSelected,
                ),
        ),
      ),
    );
  }
}
