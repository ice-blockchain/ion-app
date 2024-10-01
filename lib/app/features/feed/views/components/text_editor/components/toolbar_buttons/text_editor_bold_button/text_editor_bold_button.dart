// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/hooks/use_text_editor_font_style.dart';
import 'package:ice/generated/assets.gen.dart';

class TextEditorBoldButton extends HookWidget {
  const TextEditorBoldButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    final fontType = useTextEditorFontStyle(textEditorController);

    return ActionsToolbarButton(
      icon: Assets.svg.iconPostBoldtextOff,
      iconSelected: Assets.svg.iconPostBoldtextOn,
      onPressed: () {
        textEditorController
          ..formatSelection(Attribute.clone(Attribute.italic, null))
          ..formatSelection(Attribute.bold);
      },
      selected: fontType == FontType.bold,
    );
  }
}
