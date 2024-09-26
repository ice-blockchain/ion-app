import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block.dart';

class TextEditor extends StatelessWidget {
  const TextEditor(this.controller, {super.key, this.placeholder});
  final QuillController controller;
  final String? placeholder;

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
            placeholder: placeholder,
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
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
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
        HorizontalSpacing.zero,
        VerticalSpacing.zero,
        VerticalSpacing.zero,
        null,
      ),
    );
  }
}
