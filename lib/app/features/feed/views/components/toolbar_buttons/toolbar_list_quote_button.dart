// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarListQuoteButton extends StatelessWidget {
  const ToolbarListQuoteButton({required this.textEditorController, super.key});
  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbarButton(
      icon: Assets.svgIconArticleQuote,
      onPressed: () {
        final currentStyle = textEditorController.getSelectionStyle().attributes;

        if (currentStyle.containsKey(Attribute.blockQuote.key)) {
          textEditorController.formatSelection(Attribute.clone(Attribute.blockQuote, null));
        } else {
          textEditorController.formatSelection(Attribute.blockQuote);
        }
      },
    );
  }
}
