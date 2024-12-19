// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/image_block_local_image.dart';
import 'package:ion/app/features/feed/views/components/text_editor/components/custom_blocks/text_editor_single_image_block/image_block_network_image.dart';
import 'package:ion/app/features/nostr/model/media_attachment.dart';

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
  TextEditorSingleImageBuilder({this.media});

  final Map<String, MediaAttachment>? media;

  @override
  String get key => textEditorSingleImageKey;

  @override
  Widget build(
    BuildContext context,
    QuillController controller,
    Embed node,
    bool readOnly,
    bool inline,
    TextStyle textStyle,
  ) {
    final path = node.value.data as String;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: (Uri.tryParse(path)?.hasAbsolutePath ?? false)
                ? ImageBlockNetworkImage(path: path, media: media)
                : ImageBlockLocalImage(path: path),
          ),
        ),
      ],
    );
  }
}
