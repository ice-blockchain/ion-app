import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block.dart';

class TextEditor extends StatelessWidget {
  final QuillController controller;
  const TextEditor(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillEditor.basic(
          controller: controller,
          configurations: QuillEditorConfigurations(
            embedBuilders: [
              TextEditorSingleImageBuilder(),
            ],
            autoFocus: true,
            placeholder: context.i18n.create_post_modal_placeholder,
            customStyles: _getCustomStyles(context),
            floatingCursorDisabled: true,
          ),
        ),
      ],
    );
  }

  DefaultStyles _getCustomStyles(BuildContext context) {
    return DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.primaryText,
        ),
        HorizontalSpacing(0, 0),
        VerticalSpacing(0, 0),
        VerticalSpacing(0, 0),
        null,
      ),
      bold: context.theme.appTextThemes.body2.copyWith(
        fontWeight: FontWeight.bold,
        color: context.theme.appColors.primaryText,
      ),
      italic: context.theme.appTextThemes.body2.copyWith(
        fontStyle: FontStyle.italic,
        color: context.theme.appColors.primaryText,
      ),
      placeHolder: DefaultTextBlockStyle(
        context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.quaternaryText,
        ),
        HorizontalSpacing(0, 0),
        VerticalSpacing(0, 0),
        VerticalSpacing(0, 0),
        null,
      ),
    );
  }
}
