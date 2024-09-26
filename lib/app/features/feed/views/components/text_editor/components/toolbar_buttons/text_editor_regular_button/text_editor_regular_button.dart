import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/hooks/use_text_editor_font_style.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorRegularButton extends HookWidget {
  const TextEditorRegularButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    final fontType = useTextEditorFontStyle(textEditorController);

    return ActionsToolbarButton(
      icon: Assets.svg.iconPostRegulartextOff,
      iconSelected: Assets.svg.iconPostRegulartextOn,
      onPressed: () {
        textEditorController
          ..formatSelection(Attribute.clone(Attribute.bold, null))
          ..formatSelection(Attribute.clone(Attribute.italic, null));
      },
      selected: fontType == FontType.regular,
    );
  }
}
