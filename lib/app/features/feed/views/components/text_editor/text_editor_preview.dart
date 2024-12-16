// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/quill.dart';

class TextEditorPreview extends StatelessWidget {
  const TextEditorPreview({
    required this.content,
    super.key,
  });

  final String content;

  QuillController _getControllerFromContent(String content) {
    try {
      return decodeArticleContent(content);
    } catch (e) {
      return QuillController.basic();
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _getControllerFromContent(content),
      configurations: QuillEditorConfigurations(
        enableSelectionToolbar: false,
        floatingCursorDisabled: true,
        showCursor: false,
        enableInteractiveSelection: false,
        customStyles: getCustomStyles(context),
        embedBuilders: [
          TextEditorSingleImageBuilder(),
          TextEditorSeparatorBuilder(),
          TextEditorCodeBuilder(),
        ],
        disableClipboard: true,
        customStyleBuilder: (attribute) => customTextStyleBuilder(attribute, context),
      ),
    );
  }
}
