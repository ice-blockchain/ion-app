// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/unknown/text_editor_unknown_embed_builder.dart';
import 'package:ion/app/components/text_editor/custom_recognizer_builder.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/extensions/delta.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/browser/browser.dart';

class TextEditorPreview extends HookWidget {
  const TextEditorPreview({
    required this.content,
    this.enableInteractiveSelection = false,
    this.media,
    this.maxHeight,
    this.customStyles,
    this.tagsColor,
    this.scrollable = true,
    this.authorPubkey,
    this.eventReference,
    super.key,
  });

  final Delta content;
  final bool enableInteractiveSelection;
  final Map<String, MediaAttachment>? media;
  final DefaultStyles? customStyles;
  final double? maxHeight;
  final bool scrollable;
  final Color? tagsColor;
  final String? authorPubkey;
  final String? eventReference;

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

    if (content.isBlank) {
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
      authorPubkey: authorPubkey,
      eventReference: eventReference,
    );
  }
}

class _QuillFormattedContent extends ConsumerWidget {
  const _QuillFormattedContent({
    required this.controller,
    required this.enableInteractiveSelection,
    this.customStyles,
    this.media,
    this.maxHeight,
    this.tagsColor,
    this.scrollable = true,
    this.authorPubkey,
    this.eventReference,
  });

  final QuillController controller;
  final bool enableInteractiveSelection;
  final DefaultStyles? customStyles;
  final Map<String, MediaAttachment>? media;
  final double? maxHeight;
  final bool scrollable;
  final Color? tagsColor;
  final String? authorPubkey;
  final String? eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveStyles = customStyles ?? textEditorStyles(context);

    return QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(
        onLaunchUrl: (url) => openDeepLinkOrInAppBrowser(url, ref),
        floatingCursorDisabled: true,
        showCursor: false,
        scrollable: scrollable,
        enableInteractiveSelection: enableInteractiveSelection,
        customStyles: effectiveStyles,
        maxHeight: maxHeight,
        embedBuilders: [
          TextEditorSingleImageBuilder(
            media: media,
            authorPubkey: authorPubkey,
            eventReference: eventReference,
          ),
          TextEditorSeparatorBuilder(readOnly: true),
          TextEditorCodeBuilder(readOnly: true),
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
