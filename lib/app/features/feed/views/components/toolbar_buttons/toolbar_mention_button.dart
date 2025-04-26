// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/text_editor.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarMentionButton extends ConsumerWidget {
  const ToolbarMentionButton({
    required this.textEditorController,
    required this.textEditorKey,
    super.key,
  });

  final QuillController textEditorController;
  final GlobalKey<TextEditorState> textEditorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconFieldNickname,
      onPressed: () {
        final cursorPosition = textEditorController.selection.baseOffset;
        if (cursorPosition >= 0) {
          textEditorController
            ..replaceText(cursorPosition, 0, '@', null)
            ..updateSelection(
              TextSelection.collapsed(offset: cursorPosition + 1),
              ChangeSource.local,
            );

          final textEditorState = textEditorKey.currentState;
          if (textEditorState != null) {
            textEditorState.mentionsHashtagsHandler.triggerListener();
          }
        }
      },
    );
  }
}
