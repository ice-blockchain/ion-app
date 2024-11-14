// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/poll/poll.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/remove_block.dart';

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
    required this.controller,
  });

  final QuillController controller;

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
    return Padding(
      padding: EdgeInsets.only(right: 23.0.s),
      child: Poll(
        onRemove: () {
          removeBlock(controller, node);
        },
      ),
    );
  }
}
