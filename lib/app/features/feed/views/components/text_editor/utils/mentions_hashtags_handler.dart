// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/hashtags_suggestions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/mentions_suggestions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/mocked_data.dart';
import 'package:ion/app/services/logger/logger.dart';

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

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 50), () {
      Logger.log('Debounced cursorIndex: $cursorIndex, lastTagIndex: $lastTagIndex, text: "$text"');

      if (cursorIndex > 0) {
        final char = text.substring(cursorIndex - 1, cursorIndex);
        Logger.log('Character detected: "$char"');

        if (char == '#' || char == '@') {
          taggingCharacter = char;
          lastTagIndex = cursorIndex - 1;
          isLinkApplied = false;
          Logger.log('Tagging character "$char" detected. Setting lastTagIndex: $lastTagIndex');
          _showOverlay();
        } else if (char == ' ' || char == '\n') {
          Logger.log('Space or newline detected. Applying tag if needed.');
          _applyTagIfNeeded(cursorIndex);
          _removeOverlay();
        } else if (lastTagIndex != -1) {
          final currentTagText = text.substring(lastTagIndex, cursorIndex);
          Logger.log('Updating suggestions with currentTagText: "$currentTagText"');

          _updateSuggestions(currentTagText);

          if (lastTagIndex >= 0 && cursorIndex > lastTagIndex) {
            Logger.log(
              'Applying Custom Attribute from lastTagIndex: $lastTagIndex to cursorIndex: $cursorIndex',
            );
            try {
              final attribute = taggingCharacter == '@'
                  ? MentionAttribute.withValue(currentTagText)
                  : HashtagAttribute.withValue(currentTagText);

              controller.formatText(
                lastTagIndex,
                cursorIndex - lastTagIndex,
                attribute,
              );
            } catch (e) {
              Logger.log('Error applying formatText: $e');
            }
          }
        }
      }
    });
  }

  void _applyTagIfNeeded(int cursorIndex) {
    Logger.log('Applying tag at cursorIndex: $cursorIndex, lastTagIndex: $lastTagIndex');

    if (overlayEntry != null && lastTagIndex != -1) {
      final tagText = controller.document.toPlainText().substring(lastTagIndex, cursorIndex);

      final attribute = taggingCharacter == '@'
          ? MentionAttribute.withValue(tagText)
          : HashtagAttribute.withValue(tagText);

      if (lastTagIndex >= 0 && cursorIndex > lastTagIndex) {
        Logger.log('Finalizing tag formatting for tagText: "$tagText" with attribute: $attribute');

        try {
          controller
            ..replaceText(
              lastTagIndex,
              cursorIndex - lastTagIndex,
              tagText,
              null,
            )
            ..formatText(lastTagIndex, tagText.length, attribute);
        } catch (e) {
          Logger.log('Error in _applyTagIfNeeded while formatting text: $e');
        }
      }

      lastTagIndex = -1;
      isLinkApplied = false;
      Logger.log('Reset lastTagIndex and isLinkApplied after applying tag.');
    }
  }

  void _focusListener() {
    if (!focusNode.hasFocus) _removeOverlay();
  }

  void _updateSuggestions(String query) {
    if (taggingCharacter == '#') {
      suggestions.value = _getHashTagSuggestions(query);
    } else if (taggingCharacter == '@') {
      suggestions.value = _getMentionSuggestions(query);
    }
  }

  List<String> _getHashTagSuggestions(String query) {
    return hashtags.where((String tag) => tag.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<String> _getMentionSuggestions(String query) {
    return mentions
        .where((String mention) => mention.toLowerCase().contains(query.toLowerCase()))
        .toList();
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

    final topPosition = screenHeight -
        keyboardHeight -
        suggestions.value.length * hashtagItemSize -
        hashtagContainerPadding -
        toolbarHeight;

    return OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: topPosition,
        right: 0,
        child: taggingCharacter == '@'
            ? MentionsSuggestions(
                suggestions: suggestions.value,
                onSuggestionSelected: _onSuggestionSelected,
              )
            : HashtagsSuggestions(
                suggestions: suggestions.value,
                onSuggestionSelected: _onSuggestionSelected,
              ),
      ),
    );
  }

  void _onSuggestionSelected(String suggestion) {
    final cursorIndex = controller.selection.baseOffset;
    final attribute = taggingCharacter == '@'
        ? MentionAttribute.withValue(suggestion)
        : HashtagAttribute.withValue(suggestion);

    Logger.log('Suggestion selected: "$suggestion", applying attribute: $attribute');

    try {
      controller
        ..replaceText(
          lastTagIndex,
          cursorIndex - lastTagIndex,
          suggestion,
          null,
        )
        ..formatText(lastTagIndex, suggestion.length, attribute);

      final newCursorIndex = lastTagIndex + suggestion.length;
      controller.updateSelection(
        TextSelection.collapsed(offset: newCursorIndex),
        ChangeSource.local,
      );

      lastTagIndex = -1;
      taggingCharacter = '';
    } catch (e) {
      Logger.log('Error in _onSuggestionSelected: $e');
    }

    _removeOverlay();
  }
}
