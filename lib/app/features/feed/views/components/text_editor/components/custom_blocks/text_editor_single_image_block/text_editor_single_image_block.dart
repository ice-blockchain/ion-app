// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

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
class TextEditorSingleImageBuilder extends EmbedBuilder {
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
    return const SizedBox.shrink();

    return SizedBox.square(
      dimension: 100.0.s,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Consumer(
          builder: (context, ref, child) {
            final assetEntity = ref.watch(assetEntityProvider(path)).valueOrNull;
            if (assetEntity == null) {
              return const SizedBox.shrink();
            }
            return Image(
              image: AssetEntityImageProvider(
                assetEntity,
                isOriginal: false,
                thumbnailSize: const ThumbnailSize.square(300),
              ),
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}
