// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/code_block_content.dart';
import 'package:ion/app/components/text_editor/utils/remove_block.dart';
import 'package:ion/app/extensions/extensions.dart';

const textEditorCodeKey = 'text-editor-code';

///
/// Embeds a code block in the text editor.
///
class TextEditorCodeEmbed extends CustomBlockEmbed {
  TextEditorCodeEmbed({required String content}) : super(textEditorCodeKey, content);

  static BlockEmbed code({required String content}) => TextEditorCodeEmbed(content: content);

  String get content => data as String;

  @override
  Map<String, dynamic> toJson() => {
        textEditorCodeKey: content,
      };
}

///
/// Embed builder for [TextEditorCodeBuilder].
///
class TextEditorCodeBuilder extends EmbedBuilder {
  TextEditorCodeBuilder({this.readOnly = false});

  final bool readOnly;

  @override
  String get key => textEditorCodeKey;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final content = embedContext.node.value.data as String? ?? '';

    return Container(
      padding: EdgeInsets.only(top: 12.0.s),
      decoration: BoxDecoration(
        color: context.theme.appColors.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0.s),
        border: Border.all(
          color: context.theme.appColors.onTerararyFill,
        ),
      ),
      child: Column(
        children: [
          CodeBlockContent(
            content: content,
            readOnly: readOnly,
            onRemoveBlock: () => removeBlock(embedContext.controller, embedContext.node),
          ),
        ],
      ),
    );
  }
}
