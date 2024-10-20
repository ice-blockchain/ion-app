// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_code_button/toolbar_code_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_hashtag_button/toolbar_hashtag_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_image_button/toolbar_image_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_list_dots_button/toolbar_list_dots_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_list_numbers_button/toolbar_list_numbers_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_list_quote_button/toolbar_list_quote_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_mention_button/toolbar_mention_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_separator_button/toolbar_separator_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_typography_button/toolbar_typography_button.dart';

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
        ToolbarListDotsButton(textEditorController: textEditorController),
        ToolbarListNumbersButton(textEditorController: textEditorController),
        ToolbarListQuoteButton(textEditorController: textEditorController),
        ToolbarMentionButton(textEditorController: textEditorController),
        ToolbarHashtagButton(textEditorController: textEditorController),
        ToolbarSeparatorButton(textEditorController: textEditorController),
        ToolbarCodeButton(textEditorController: textEditorController),
      ],
    );
  }
}
