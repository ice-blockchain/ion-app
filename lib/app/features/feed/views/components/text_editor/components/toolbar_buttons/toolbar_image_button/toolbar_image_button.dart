// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/gallery_permission_button.dart';

class ToolbarImageButton extends StatelessWidget {
  const ToolbarImageButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return GalleryPermissionButton(
      onMediaSelected: (mediaFiles) {
        if (mediaFiles != null && mediaFiles.isNotEmpty) {
          addSingleImageBlock(textEditorController);
        }
      },
    );
  }

  void addSingleImageBlock(QuillController textEditorController) {
    final index = textEditorController.selection.baseOffset;
    textEditorController
      ..replaceText(
        index,
        0, // No text to delete
        TextEditorSingleImageEmbed.image('https://picsum.photos/600/300'),
        TextSelection.collapsed(
          offset: textEditorController.document.length,
        ), // Move cursor to the end of the document
      )
      ..replaceText(
        index + 1,
        0,
        '\n',
        TextSelection.collapsed(offset: textEditorController.document.length),
      );
  }
}
