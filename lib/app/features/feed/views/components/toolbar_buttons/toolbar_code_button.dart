// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarCodeButton extends StatelessWidget {
  const ToolbarCodeButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconArticleCode,
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
          TextEditorCodeEmbed(content: ''),
        );

        textEditorController.document.insert(index + 1, '\n');
        textEditorController.moveCursorToPosition(index + 2);
      },
    );
  }
}
