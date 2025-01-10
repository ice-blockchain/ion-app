// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/quill.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

class TextEditorPreview extends HookWidget {
  const TextEditorPreview({
    required this.content,
    this.media,
    super.key,
  });

  final String content;
  final Map<String, MediaAttachment>? media;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () {
        try {
          return decodeArticleContent(content);
        } catch (e) {
          return null;
        }
      },
      [content],
    );

    if (controller == null) {
      return const SizedBox.shrink();
    }
    return QuillEditor.basic(
      controller: controller,
      configurations: QuillEditorConfigurations(
        enableSelectionToolbar: false,
        floatingCursorDisabled: true,
        showCursor: false,
        enableInteractiveSelection: false,
        customStyles: getCustomStyles(context),
        embedBuilders: [
          TextEditorSingleImageBuilder(media: media),
          TextEditorSeparatorBuilder(),
          TextEditorCodeBuilder(),
        ],
        disableClipboard: true,
        customStyleBuilder: (attribute) => customTextStyleBuilder(attribute, context),
      ),
    );
  }
}
