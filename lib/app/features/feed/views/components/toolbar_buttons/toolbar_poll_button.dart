// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_poll_block/text_editor_poll_block.dart';
import 'package:ion/app/features/feed/create_post/views/pages/post_editor_modal/hooks/use_has_poll.dart';
import 'package:ion/app/features/feed/views/components/actions_toolbar_button/actions_toolbar_button.dart';
import 'package:ion/generated/assets.gen.dart';

class ToolbarPollButton extends HookWidget {
  const ToolbarPollButton({
    required this.textEditorController,
    this.onPressed,
    super.key,
  });

  final QuillController textEditorController;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final hasPoll = useHasPoll(textEditorController);

    return ActionsToolbarButton(
      icon: Assets.svg.iconPostPoll,
      enabled: !hasPoll,
      onPressed: () {
        final index = textEditorController.selection.baseOffset;

        textEditorController.document.insert(
          index,
          BlockEmbed.custom(
            TextEditorPollEmbed(),
          ),
        );

        textEditorController.moveCursorToPosition(index + 1);

        onPressed?.call();
      },
    );
  }
}
