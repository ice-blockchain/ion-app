// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/code_block_content.dart';

const textEditorCodeKey = 'text-editor-code';

///
/// Embeds a code block in the text editor.
///
class TextEditorCodeEmbed extends CustomBlockEmbed {
  TextEditorCodeEmbed() : super(textEditorCodeKey, '');
}

///
/// Embed builder for [TextEditorCodeBuilder].
///
class TextEditorCodeBuilder extends EmbedBuilder {
  @override
  String get key => textEditorCodeKey;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return Container(
      padding: EdgeInsets.all(12.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0.s),
        border: Border.all(
          color: context.theme.appColors.onTerararyFill,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 20.0.s,
            width: 100.0.s,
            color: Colors.amber,
          ),
          SizedBox(height: 8.0.s),
          const CodeBlockContent(),
        ],
      ),
    );
  }
}
