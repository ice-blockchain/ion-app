// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_add_answer_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_answers_list_view.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_close_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_length_button.dart';
import 'package:ice/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_poll_block/poll_title.dart';

const textEditorPollKey = 'text-editor-poll';

///
/// Embeds a poll in the text editor.
///

class TextEditorPollEmbed extends CustomBlockEmbed {
  TextEditorPollEmbed() : super(textEditorPollKey, '');
}

///
/// Embed builder for [TextEditorPollBuilder].
///

class TextEditorPollBuilder extends EmbedBuilder {
  TextEditorPollBuilder({
    this.onPollLengthPress,
    this.onRemovePollPress,
  });
  final VoidCallback? onPollLengthPress;
  final ValueChanged<Embed>? onRemovePollPress;

  @override
  String get key => textEditorPollKey;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 23.0.s),
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.appColors.onPrimaryAccent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.theme.appColors.onTerararyFill,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.s),
                  child: const Column(
                    children: [
                      PollTitle(),
                      PollAnswersListView(),
                      PollAddAnswerButton(),
                    ],
                  ),
                ),
              ),
            ),
            PollLengthButton(
              onPollLengthPress: () {
                onPollLengthPress?.call();
              },
            ),
          ],
        ),
        PollCloseButton(
          onClosePress: () => onRemovePollPress?.call(node),
        ),
      ],
    );
  }
}
