// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_profile_block/text_editor_profile_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/unknown/text_editor_unknown_embed_builder.dart';
import 'package:ion/app/components/text_editor/custom_recognizer_builder.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';

class TextEditorPreview extends HookWidget {
  const TextEditorPreview({
    required this.content,
    this.enableInteractiveSelection = false,
    this.media,
    this.maxHeight,
    this.customStyles,
    this.tagsColor,
    this.scrollable = true,
    super.key,
  });

  final Delta content;
  final bool enableInteractiveSelection;
  final Map<String, MediaAttachment>? media;
  final DefaultStyles? customStyles;
  final double? maxHeight;
  final bool scrollable;
  final Color? tagsColor;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(
      () => QuillController(
        document: Document.fromDelta(content),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      ),
      [content],
    );

    if (_isEmptyContent(content)) {
      return const SizedBox.shrink();
    }

    return _QuillFormattedContent(
      tagsColor: tagsColor,
      controller: controller,
      customStyles: customStyles,
      media: media,
      maxHeight: maxHeight,
      scrollable: scrollable,
      enableInteractiveSelection: enableInteractiveSelection,
    );
  }

  bool _isEmptyContent(Delta delta) => delta.length == 1 && delta.first.value == '\n';
}

class _QuillFormattedContent extends StatelessWidget {
  const _QuillFormattedContent({
    required this.controller,
    required this.enableInteractiveSelection,
    this.customStyles,
    this.media,
    this.maxHeight,
    this.tagsColor,
    this.scrollable = true,
  });

  final QuillController controller;
  final bool enableInteractiveSelection;
  final DefaultStyles? customStyles;
  final Map<String, MediaAttachment>? media;
  final double? maxHeight;
  final bool scrollable;
  final Color? tagsColor;

  @override
  Widget build(BuildContext context) {
    final effectiveStyles = customStyles ?? textEditorStyles(context);

    return QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(
        floatingCursorDisabled: true,
        showCursor: false,
        scrollable: scrollable,
        enableInteractiveSelection: enableInteractiveSelection,
        customStyles: effectiveStyles,
        maxHeight: maxHeight,
        embedBuilders: [
          TextEditorSingleImageBuilder(media: media),
          TextEditorSeparatorBuilder(readOnly: true),
          TextEditorCodeBuilder(readOnly: true),
          TextEditorProfileBuilder(),
        ],
        unknownEmbedBuilder: TextEditorUnknownEmbedBuilder(),
        disableClipboard: true,
        customStyleBuilder: (attribute) =>
            customTextStyleBuilder(attribute, context, tagsColor: tagsColor),
        customRecognizerBuilder: (attribute, leaf) => customRecognizerBuilder(
          context,
          attribute,
        ),
      ),
    );
  }
}
