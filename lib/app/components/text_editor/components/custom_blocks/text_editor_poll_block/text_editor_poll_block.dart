// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/utils/remove_block.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/views/components/poll/poll.dart';

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
    EmbedContext embedContext,
  ) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 23.0.s),
      child: Poll(
        onRemove: () {
          removeBlock(embedContext.controller, embedContext.node);
        },
      ),
    );
  }
}
