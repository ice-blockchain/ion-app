// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/toolbar_buttons/toolbar_buttons.dart';

class ArticleMainToolbar extends StatelessWidget {
  const ArticleMainToolbar({
    required this.textEditorController,
    required this.onTypographyPressed,
    super.key,
  });

  final QuillController textEditorController;
  final VoidCallback onTypographyPressed;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbar(
      actions: [
        ToolbarImageButton(textEditorController: textEditorController),
        ToolbarTypographyButton(
          textEditorController: textEditorController,
          onPressed: onTypographyPressed,
        ),
        ToolbarListButton(textEditorController: textEditorController, listType: Attribute.ul),
        ToolbarListQuoteButton(textEditorController: textEditorController),
        ToolbarMentionButton(textEditorController: textEditorController),
        ToolbarHashtagButton(textEditorController: textEditorController),
        ToolbarSeparatorButton(textEditorController: textEditorController),
        ToolbarCodeButton(textEditorController: textEditorController),
      ],
    );
  }
}
