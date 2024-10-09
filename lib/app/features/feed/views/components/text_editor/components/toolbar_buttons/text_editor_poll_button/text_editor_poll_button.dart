// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorPollButton extends StatelessWidget {
  const TextEditorPollButton({
    required this.textEditorController,
    super.key,
  });

  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconPostPoll,
      onPressed: () {
        final index = textEditorController.selection.baseOffset;

        textEditorController.document.insert(
          index,
          BlockEmbed.custom(
            TextEditorPollEmbed(),
          ),
        );

        textEditorController.moveCursorToPosition(index + 1);

        QuillEditorConfigurations(
          embedBuilders: [
            TextEditorPollBuilder(),
          ],
        );
      },
    );
  }
}
