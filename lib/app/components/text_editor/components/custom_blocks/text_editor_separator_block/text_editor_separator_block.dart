// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator.dart';
import 'package:ion/app/components/text_editor/utils/remove_block.dart';

const textEditorSeparatorKey = 'text-editor-separator';

///
/// Embeds a separator block in the text editor.
///
class TextEditorSeparatorEmbed extends CustomBlockEmbed {
  TextEditorSeparatorEmbed() : super(textEditorSeparatorKey, '---');

  static BlockEmbed separatorBlock() => TextEditorSeparatorEmbed();
}

///
/// Embed builder for [TextEditorSeparatorEmbed].
///
class TextEditorSeparatorBuilder extends EmbedBuilder {
  @override
  String get key => textEditorSeparatorKey;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    return TextEditorSeparator(
      onRemove: () => {
        removeBlock(controller, node),
      },
    );
  }
}
