// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:ion/app/components/text_editor/attributes.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_code_block/text_editor_code_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_separator_block/text_editor_separator_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/text_editor_single_image_block.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/unknown/text_editor_unknown_embed_builder.dart';
import 'package:ion/app/components/text_editor/custom_recognizer_builder.dart';
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/components/text_span_builder/text_span_builder.dart'
    as ion_text_span_builder;
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/services/text_parser/model/text_match.c.dart';
import 'package:ion/app/services/text_parser/model/text_matcher.dart';

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

    if (_isEmptyContent(content)) {
      return const SizedBox.shrink();
    }

    return enableInteractiveSelection
        ? _SelectableContentText(
            controller: controller,
            customStyles: customStyles,
          )
        : _QuillFormattedContent(
            controller: controller,
            customStyles: customStyles,
            media: media,
            maxHeight: maxHeight,
            scrollable: scrollable,
          );
  }

  bool _isEmptyContent(Delta delta) => delta.length == 1 && delta.first.value == '\n';
}

class _SelectableContentText extends StatelessWidget {
  const _SelectableContentText({
    required this.controller,
    this.customStyles,
  });

  final QuillController controller;
  final DefaultStyles? customStyles;

  @override
  Widget build(BuildContext context) {
    final effectiveStyles = customStyles ?? textEditorStyles(context);
    final delta = controller.document.toDelta();

    return SelectableText.rich(
      _buildRichTextSpanFromDelta(
        delta,
        context: context,
        styles: effectiveStyles,
      ),
      textAlign: TextAlign.start,
      contextMenuBuilder: (context, editableTextState) => _ExtendedContextMenu(
        editableTextState: editableTextState,
      ),
    );
  }

  /// Recursively builds a TextSpan tree from Quill Delta, preserving formatting and recognizers.
  TextSpan _buildRichTextSpanFromDelta(
    Delta delta, {
    required BuildContext context,
    required DefaultStyles styles,
  }) {
    final children = <InlineSpan>[];
    for (final op in delta.toList()) {
      if (op.key != 'insert') continue;
      final data = op.data;
      final attrs = op.attributes ?? {};
      if (data is String) {
        var style = styles.paragraph?.style ?? const TextStyle();
        // Bold
        if (attrs['b'] == true) {
          style = style.merge(styles.bold);
        }
        // Italic
        if (attrs['i'] == true) {
          style = style.merge(styles.italic);
        }
        // Underline
        if (attrs['u'] == true) {
          style = style.merge(const TextStyle(decoration: TextDecoration.underline));
        }
        // Link
        GestureRecognizer? recognizer;
        if (attrs.containsKey('a') && attrs['a'] != null) {
          style = style.merge(customTextStyleBuilder(Attribute.link, context));
          recognizer = TapGestureRecognizer()
            ..onTap = () => ion_text_span_builder.TextSpanBuilder.defaultOnTap(
                  context,
                  match: TextMatch(
                    data,
                    matcher: const UrlMatcher(),
                  ),
                );
        }
        // Hashtag
        if (attrs.containsKey('hashtag')) {
          style = style.merge(customTextStyleBuilder(const HashtagAttribute(''), context));
          recognizer = customRecognizerBuilder(
            context,
            HashtagAttribute.withValue(attrs['hashtag'] as String),
          );
        }
        // Mention
        if (attrs.containsKey('mention')) {
          style = style.merge(customTextStyleBuilder(const MentionAttribute(''), context));
        }
        // Cashtag
        if (attrs.containsKey('cashtag')) {
          style = style.merge(customTextStyleBuilder(const CashtagAttribute(''), context));
          recognizer = customRecognizerBuilder(
            context,
            CashtagAttribute.withValue(attrs['cashtag'] as String),
          );
        }
        children.add(TextSpan(text: data, style: style, recognizer: recognizer));
      }
    }
    return TextSpan(children: children);
  }
}

class _ExtendedContextMenu extends StatelessWidget {
  const _ExtendedContextMenu({
    required this.editableTextState,
  });

  final EditableTextState editableTextState;

  @override
  Widget build(BuildContext context) {
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
  }
}

class _QuillFormattedContent extends StatelessWidget {
  const _QuillFormattedContent({
    required this.controller,
    this.customStyles,
    this.media,
    this.maxHeight,
    this.scrollable = true,
  });

  final QuillController controller;
  final DefaultStyles? customStyles;
  final Map<String, MediaAttachment>? media;
  final double? maxHeight;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final effectiveStyles = customStyles ?? textEditorStyles(context);

    return QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(
        enableSelectionToolbar: false,
        floatingCursorDisabled: true,
        showCursor: false,
        scrollable: scrollable,
        enableInteractiveSelection: false,
        customStyles: effectiveStyles,
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
