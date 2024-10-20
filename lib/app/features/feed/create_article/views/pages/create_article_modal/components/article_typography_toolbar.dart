// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_bold_button/toolbar_bold_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_close_button/toolbar_close_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_h1_button/toolbar_h1_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_h2_button/toolbar_h2_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_h3_button/toolbar_h3_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_italic_button/toolbar_italic_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_link_button/toolbar_link_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_regular_button/toolbar_regular_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_underline_button/toolbar_underline_button.dart';

class ArticleTypographyToolbar extends StatelessWidget {
  const ArticleTypographyToolbar({
    required this.textEditorController,
    required this.onClosePressed,
    super.key,
  });

  final QuillController textEditorController;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    return ActionsToolbar(
      actions: [
        ToolbarCloseButton(
          textEditorController: textEditorController,
          onPressed: onClosePressed,
        ),
        ToolbarH1Button(textEditorController: textEditorController),
        ToolbarH2Button(textEditorController: textEditorController),
        ToolbarH3Button(textEditorController: textEditorController),
        ToolbarRegularButton(textEditorController: textEditorController),
        ToolbarBoldButton(textEditorController: textEditorController),
        ToolbarItalicButton(textEditorController: textEditorController),
        ToolbarUnderlineButton(textEditorController: textEditorController),
        ToolbarLinkButton(textEditorController: textEditorController),
      ],
    );
  }
}
