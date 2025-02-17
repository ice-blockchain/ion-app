// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarHashtagButton extends StatelessWidget {
  const ToolbarHashtagButton({
    required this.textEditorController,
    required this.textEditorKey,
    super.key,
  });
  final QuillController textEditorController;
  final GlobalKey<TextEditorState> textEditorKey;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconArticleHashtag,
      onPressed: () {
        final cursorPosition = textEditorController.selection.baseOffset;
        if (cursorPosition >= 0) {
          textEditorController
            ..replaceText(cursorPosition, 0, '#', null)
            ..formatText(cursorPosition, 1, const HashtagAttribute.withValue('#'))
            ..updateSelection(
              TextSelection.collapsed(offset: cursorPosition + 1),
              ChangeSource.local,
            );

          final textEditorState = textEditorKey.currentState;
          if (textEditorState != null) {
            textEditorState.mentionsHashtagsHandler
              ..taggingCharacter = '#'
              ..lastTagIndex = cursorPosition
              ..triggerListener();
          }
        }
      },
    );
  }
}
