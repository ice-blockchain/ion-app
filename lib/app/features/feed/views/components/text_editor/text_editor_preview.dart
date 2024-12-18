// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/features/feed/views/components/text_editor/utils/quill.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';
import 'package:ion/app/services/logger/logger.dart';

class TextEditorPreview extends StatelessWidget {
  const TextEditorPreview({
    required this.content,
    this.media,
    super.key,
  });

  final String content;
  final Map<String, MediaAttachment>? media;

  QuillController _getControllerFromContent(String content) {
    try {
      return decodeArticleContent(content);
    } catch (e) {
      return QuillController.basic();
    }
  }

  @override
  Widget build(BuildContext context) {
    Logger.log('media: $media');
    return QuillEditor.basic(
      controller: _getControllerFromContent(content),
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
