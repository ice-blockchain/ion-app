// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/unknown/text_editor_unknown_embed_builder.dart';
import 'package:ion/app/components/text_editor/custom_recognizer_builder.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

class TextEditorPreview extends HookWidget {
  const TextEditorPreview({
    required this.content,
    this.enableInteractiveSelection = false,
    this.media,
    this.maxHeight,
    this.customStyles,
    this.scrollable = true,
    super.key,
  });

  final Delta content;
  final bool enableInteractiveSelection;
  final Map<String, MediaAttachment>? media;
  final DefaultStyles? customStyles;
  final double? maxHeight;
  final bool scrollable;

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

    if (content.length == 1 && content.first.value == '\n') {
      return const SizedBox.shrink();
    }

    if (enableInteractiveSelection) {
      return SelectableText.rich(
        TextSpan(
          text: controller.document.toPlainText(),
          style: (customStyles ?? textEditorStyles(context))
              .paragraph
              ?.style
              .copyWith(color: customStyles?.paragraph?.style.color),
        ),
        textAlign: TextAlign.left,
        contextMenuBuilder: (context, editableTextState) {
          final buttonItems = editableTextState.contextMenuButtonItems;

          final hasSelectAll = buttonItems.any(
            (item) => item.type == ContextMenuButtonType.selectAll,
          );

          if (!hasSelectAll) {
            final copyIndex = buttonItems.indexWhere(
              (item) => item.type == ContextMenuButtonType.copy,
            );

            final insertIndex = copyIndex != -1 ? copyIndex + 1 : 0;

            buttonItems.insert(
              insertIndex,
              ContextMenuButtonItem(
                type: ContextMenuButtonType.selectAll,
                onPressed: () {
                  editableTextState.selectAll(SelectionChangedCause.toolbar);
                },
              ),
            );
          }

          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: editableTextState.contextMenuAnchors,
            buttonItems: buttonItems,
          );
        },
      );
    }

    return QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(
        enableSelectionToolbar: false,
        floatingCursorDisabled: true,
        showCursor: false,
        scrollable: scrollable,
        enableInteractiveSelection: false,
        customStyles: customStyles ?? textEditorStyles(context),
        maxHeight: maxHeight,
        embedBuilders: [
          TextEditorSingleImageBuilder(media: media),
          TextEditorSeparatorBuilder(readOnly: true),
          TextEditorCodeBuilder(readOnly: true),
        ],
        unknownEmbedBuilder: TextEditorUnknownEmbedBuilder(),
        disableClipboard: true,
        customStyleBuilder: (attribute) => customTextStyleBuilder(attribute, context),
        customRecognizerBuilder: (attribute, leaf) => customRecognizerBuilder(context, attribute),
      ),
    );
  }
}
