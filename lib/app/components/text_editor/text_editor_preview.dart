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
import 'package:ion/app/components/text_editor/utils/text_editor_styles.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/router/app_routes.c.dart';

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

    return QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(
        enableSelectionToolbar: enableInteractiveSelection,
        floatingCursorDisabled: true,
        showCursor: false,
        scrollable: scrollable,
        enableInteractiveSelection: enableInteractiveSelection,
        customStyles: customStyles ?? textEditorStyles(context),
        maxHeight: maxHeight,
        embedBuilders: [
          TextEditorSingleImageBuilder(media: media),
          TextEditorSeparatorBuilder(readOnly: true),
          TextEditorCodeBuilder(readOnly: true),
        ],
        customRecognizerBuilder: (attribute, leaf) {
          //TODO:make reusable and apply to every QuillEditor
          //TODO:check if it doesn't break the default recognizer e.g. for links
          if (attribute.key == HashtagAttribute.attributeKey) {
            return TapGestureRecognizer()
              ..onTap = () {
                FeedAdvancedSearchRoute(query: attribute.value as String).go(context);
              };
          }
          return null;
        },
        disableClipboard: !enableInteractiveSelection,
        customStyleBuilder: (attribute) => customTextStyleBuilder(attribute, context),
      ),
    );
  }
}
