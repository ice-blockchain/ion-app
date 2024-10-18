// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:markdown_quill/markdown_quill.dart';

///
/// Generates markdown from a delta content with custom embed handlers
/// Delta content is the document type of a Quill editor (text editor)
///
String generateMarkdownFromDelta(Delta content) {
  final markdown = DeltaToMarkdown(
    customEmbedHandlers: {
      textEditorSingleImageKey: (embed, out) {
        out.write('![image](${embed.value.data})');
      },
    },
  ).convert(content);

  return markdown;
}
