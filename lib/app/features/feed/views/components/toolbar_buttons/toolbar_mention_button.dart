// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarMentionButton extends StatelessWidget {
  const ToolbarMentionButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
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
        }
      },
    );
  }
}
