// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/mocked_data.dart';

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
  final ValueNotifier<List<String>> suggestions = ValueNotifier([]);

  void initialize() {
    controller.addListener(_editorListener);
    focusNode.addListener(_focusListener);
  }

  void dispose() {
    controller.removeListener(_editorListener);
    focusNode.removeListener(_focusListener);
    _removeOverlay();
  }

  void _editorListener() {
    final cursorIndex = controller.selection.baseOffset;
    final text = controller.document.toPlainText();

    if (cursorIndex > 0) {
      final char = text.substring(cursorIndex - 1, cursorIndex);

      if (char == '#' || char == '@') {
        taggingCharacter = char;
        lastTagIndex = cursorIndex - 1;
        controller.formatText(lastTagIndex, 1, LinkAttribute('https://someurl.com/$char'));

        _showOverlay();
      } else if (char == ' ' || char == '\n') {
        _applyTagIfNeeded(cursorIndex);
        _removeOverlay();
      } else if (lastTagIndex != -1) {
        _updateSuggestions(text.substring(lastTagIndex, cursorIndex));
      }
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

  void _applyTagIfNeeded(int cursorIndex) {
    if (overlayEntry != null && lastTagIndex != -1) {
      final tag = controller.document.toPlainText().substring(lastTagIndex, cursorIndex);
      controller.replaceText(
        lastTagIndex,
        cursorIndex - lastTagIndex,
        tag,
        null,
      );
      _removeOverlay();
    }
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
    final textPosition = _getCursorPosition();

    return OverlayEntry(
      builder: (context) => Positioned(
        left: textPosition.dx,
        top: textPosition.dy + 20,
        child: Material(
          elevation: 4,
          child: Container(
            width: 200,
            constraints: const BoxConstraints(maxHeight: 150),
            child: ValueListenableBuilder(
              valueListenable: suggestions,
              builder: (context, List<String> suggestions, _) {
                return ListView.builder(
                  itemCount: suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = suggestions[index];
                    return ListTile(
                      title: Text(suggestion),
                      onTap: () => _onSuggestionSelected(suggestion),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Offset _getCursorPosition() {
    final textBox = focusNode.context!.findRenderObject()! as RenderBox;
    return textBox.localToGlobal(Offset.zero);
  }

  void _onSuggestionSelected(String suggestion) {
    final cursorIndex = controller.selection.baseOffset;
    final linkUrl = taggingCharacter == '@' ? 'mention:$suggestion' : 'hashtag:$suggestion';

    controller
      ..replaceText(lastTagIndex, cursorIndex - lastTagIndex, suggestion, null)
      ..formatSelection(LinkAttribute(linkUrl));

    _removeOverlay();
  }
}
