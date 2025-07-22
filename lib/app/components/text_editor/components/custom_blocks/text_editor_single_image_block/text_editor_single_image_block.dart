// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/image_block.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';

const textEditorSingleImageKey = 'text-editor-single-image';

///
/// Embeds a single image in the text editor.
///
class TextEditorSingleImageEmbed extends CustomBlockEmbed {
  TextEditorSingleImageEmbed(String path) : super(textEditorSingleImageKey, path);

  static BlockEmbed image(String path) => TextEditorSingleImageEmbed(path);
}

///
/// Embed builder for [TextEditorSingleImageEmbed].
///
///
/// Embed builder for [TextEditorSingleImageEmbed].
///
class TextEditorSingleImageBuilder extends EmbedBuilder {
  TextEditorSingleImageBuilder({
    this.media,
    this.authorPubkey,
    this.eventReference,
  });

  final Map<String, MediaAttachment>? media;
  final String? authorPubkey;
  final String? eventReference;

  @override
  String get key => textEditorSingleImageKey;

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    final path = embedContext.node.value.data as String;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImageBlock(
              path: path,
              media: media,
              authorPubkey: authorPubkey,
              eventReference: eventReference,
            ),
          ),
        ),
      ],
    );
  }
}
