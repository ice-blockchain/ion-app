import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block.dart';
import 'package:ice/app/features/gallery/data/models/media_data.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorImageButton extends StatelessWidget {
  const TextEditorImageButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svg.iconGalleryOpen,
      onPressed: () {
        MediaPickerRoute().push<List<MediaData>>(context);
        addSingleImageBlock(textEditorController);
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
