import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/text_editor/custom_blocks/text_editor_single_image_block.dart';

class TextEditorImageButton extends StatelessWidget {
  TextEditorImageButton(this._controller);

  final QuillController _controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final index = _controller.selection.baseOffset;

        // Insert the custom image block
        _controller.replaceText(
          index,
          0, // No text to delete
          TextEditorSingleImageEmbed.image(
              "https://images.unsplash.com/photo-1504384764586-bb4cdc1707b0?q=80&w=3570&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
          TextSelection.collapsed(
              offset: _controller.document.length), // Move cursor to the end of the document
        );
        //add a new line after the image
        _controller.replaceText(
          index + 1,
          0,
          "\n",
          TextSelection.collapsed(offset: _controller.document.length),
        );
      },
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: context.theme.appColors.primaryText,
          ),
        ),
        child: Icon(
          size: 20,
          Icons.image,
        ),
      ),
    );
  }
}
