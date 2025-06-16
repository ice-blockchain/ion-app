// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarSeparatorButton extends StatelessWidget {
  const ToolbarSeparatorButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svgIconArticleSeparator,
      onPressed: () {
        final selection = textEditorController.selection;
        var index = selection.baseOffset;

        final currentLine = textEditorController.document.querySegmentLeafNode(index).leaf;
        if (currentLine == null || currentLine.toPlainText().trim().isNotEmpty) {
          textEditorController.document.insert(index, '\n');
          index += 1;
        }

        textEditorController.document.insert(
          index,
          TextEditorSeparatorEmbed(),
        );

        textEditorController.document.insert(index + 1, '\n');
        textEditorController.moveCursorToPosition(index + 2);
      },
    );
  }
}
