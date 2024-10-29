// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/hashtags_suggestions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/mentions_suggestions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/mocked_pubkeys.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/mocked_data.dart';

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
  });

  final QuillController controller;
  final FocusNode focusNode;
  final BuildContext context;
  OverlayEntry? overlayEntry;
  String taggingCharacter = '';
  int lastTagIndex = -1;
  bool isLinkApplied = false;
  Timer? _debounce;
  final ValueNotifier<List<String>> suggestions = ValueNotifier([]);
  String? previousText;

  void initialize() {
    controller.addListener(_editorListener);
    focusNode.addListener(_focusListener);
  }

  void dispose() {
    controller.removeListener(_editorListener);
    focusNode.removeListener(_focusListener);
    _debounce?.cancel();
    _removeOverlay();
  }

  void _editorListener() {
    final cursorIndex = controller.selection.baseOffset;
    final text = controller.document.toPlainText();
    final isBackspace = previousText != null && text.length < previousText!.length;
    previousText = text;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
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
        } else if (char == ' ' || char == '\n') {
          _applyTagIfNeeded(cursorIndex);
          _removeOverlay();
        } else if (lastTagIndex != -1) {
          final currentTagText = text.substring(lastTagIndex, cursorIndex);
          _updateSuggestions(currentTagText);

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
          _removeOverlay();
          lastTagIndex = -1;
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

    _removeOverlay();
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
    if (!focusNode.hasFocus) _removeOverlay();
  }

  void _updateSuggestions(String query) {
    List<String> newSuggestions;
    if (taggingCharacter == '#') {
      newSuggestions = _getHashTagSuggestions(query);
    } else {
      newSuggestions = [];
    }

    suggestions.value = newSuggestions;
    _showOverlay();
  }

  List<String> _getHashTagSuggestions(String query) {
    return hashtags.where((String tag) => tag.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void _showOverlay() {
    _removeOverlay();
    overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(overlayEntry!);
  }

  void _removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final mockedPubKeys = getRandomPubKeys();

    final itemsLength = taggingCharacter == '@'
        ? (mockedPubKeys.length > maxMentionsLength ? maxMentionsLength : mockedPubKeys.length)
        : (suggestions.value.length > maxHashtagsLength
            ? maxHashtagsLength
            : suggestions.value.length);
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
                  suggestions: mockedPubKeys,
                  onSuggestionSelected: _onSuggestionSelected,
                )
              : HashtagsSuggestions(
                  suggestions: suggestions.value,
                  onSuggestionSelected: _onSuggestionSelected,
                ),
        ),
      ),
    );
  }
}
