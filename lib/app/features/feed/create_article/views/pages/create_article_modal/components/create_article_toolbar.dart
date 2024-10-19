// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar/actions_toolbar.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_bold_button/toolbar_bold_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_close_button/toolbar_close_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_code_button/toolbar_code_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_h1_button/toolbar_h1_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_h2_button/toolbar_h2_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_h3_button/toolbar_h3_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_hashtag_button/toolbar_hashtag_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_image_button/toolbar_image_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_italic_button/toolbar_italic_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_list_dots_button/toolbar_list_dots_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_list_numbers_button/toolbar_list_numbers_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_list_quote_button/toolbar_list_quote_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_mention_button/toolbar_mention_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_regular_button/toolbar_regular_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_separator_button/toolbar_separator_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_typography_button/toolbar_typography_button.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/toolbar_buttons/toolbar_underlign_button/toolbar_underlign_button.dart';

class CreateArticleToolbar extends HookWidget {
  const CreateArticleToolbar({
    required this.textEditorController,
    super.key,
  });

  final QuillController textEditorController;

  @override
  Widget build(BuildContext context) {
    final isTypographyToolbarVisible = useState(false);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isTypographyToolbarVisible.value
          ? _buildSecondaryToolbar(context, isTypographyToolbarVisible)
          : _buildMainToolbar(context, isTypographyToolbarVisible),
    );
  }

  Widget _buildMainToolbar(BuildContext context, ValueNotifier<bool> isTypographyToolbarVisible) {
    return ActionsToolbar(
      actions: [
        ToolbarImageButton(textEditorController: textEditorController),
        ToolbarTypographyButton(
          textEditorController: textEditorController,
          onPressed: () {
            isTypographyToolbarVisible.value = true;
          },
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

  Widget _buildSecondaryToolbar(
    BuildContext context,
    ValueNotifier<bool> isTypographyToolbarVisible,
  ) {
    return ActionsToolbar(
      actions: [
        ToolbarCloseButton(
          textEditorController: textEditorController,
          onPressed: () {
            isTypographyToolbarVisible.value = false;
          },
        ),
        ToolbarH1Button(textEditorController: textEditorController),
        ToolbarH2Button(textEditorController: textEditorController),
        ToolbarH3Button(textEditorController: textEditorController),
        ToolbarRegularButton(textEditorController: textEditorController),
        ToolbarBoldButton(textEditorController: textEditorController),
        ToolbarItalicButton(textEditorController: textEditorController),
        ToolbarUnderlineButton(textEditorController: textEditorController),
      ],
    );
  }
}
