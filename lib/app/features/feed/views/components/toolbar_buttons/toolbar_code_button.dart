// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/create_article/providers/draft_article_provider.c.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:uuid/uuid.dart';

String generateCodeBlockId() => const Uuid().v4();

const String codeBlockIdAttr = 'code-block-id';

class ToolbarCodeButton extends ConsumerWidget {
  const ToolbarCodeButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ActionsToolbarButton(
      icon: Assets.svgIconArticleCode,
      onPressed: () {
        final selection = textEditorController.selection;
        var index = selection.baseOffset;

        final currentLine = textEditorController.document.querySegmentLeafNode(index).leaf;
        if (currentLine == null || currentLine.toPlainText().trim().isNotEmpty) {
          textEditorController.document.insert(index, '\n');
          index += 1;
        }

        final codeBlockId = generateCodeBlockId();

        ref.read(draftArticleProvider.notifier).updateCodeBlock(codeBlockId, '');

        textEditorController.document.insert(
          index,
          TextEditorCodeEmbed.code(codeBlockId),
        );

        textEditorController.document.insert(index + 1, '\n');
        textEditorController.moveCursorToPosition(index + 2);
      },
    );
  }
}
