// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/gallery_permission_button.dart';
import 'package:ion/app/services/media_service/media_service.c.dart';

class ToolbarImageButton extends StatelessWidget {
  const ToolbarImageButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return GalleryPermissionButton(
      onMediaSelected: (mediaFiles) {
        if (mediaFiles != null && mediaFiles.isNotEmpty) {
          for (final mediaFile in mediaFiles) {
            addSingleImageBlock(textEditorController, mediaFile);
          }
        }
      },
    );
  }

  void addSingleImageBlock(QuillController textEditorController, MediaFile mediaFile) {
    final index = textEditorController.selection.baseOffset;
    textEditorController
      ..replaceText(
        index,
        0,
        TextEditorSingleImageEmbed.image(mediaFile.path),
        TextSelection.collapsed(
          offset: textEditorController.document.length,
        ),
      )
      ..replaceText(
        index + 1,
        0,
        '\n',
        TextSelection.collapsed(offset: textEditorController.document.length),
      );
  }
}
