// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/image_aspect_ratio_cache.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: (Uri.tryParse(path)?.hasAbsolutePath ?? false)
                ? Consumer(
                    builder: (context, ref, child) {
                      final aspectRatioCache = ref.watch(imageAspectRatioCacheProvider);
                      final futureAspectRatio = aspectRatioCache.getAspectRatio(path);
                      return FutureBuilder<MediaAspectRatioResult>(
                        future: futureAspectRatio,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }
                          if (snapshot.hasError || !snapshot.hasData) {
                            return const SizedBox.shrink();
                          }
                          return AspectRatio(
                            aspectRatio: snapshot.data!.aspectRatio,
                            child: Image.network(
                              path,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Consumer(
                    builder: (context, ref, child) {
                      final assetEntity = ref.watch(assetEntityProvider(path)).valueOrNull;
                      if (assetEntity == null) {
                        return const SizedBox.shrink();
                      }
                      return AspectRatio(
                        aspectRatio: attachedMediaAspectRatio(
                          [MediaAspectRatio.fromAssetEntity(assetEntity)],
                        ).aspectRatio,
                        child: Image(
                          image: AssetEntityImageProvider(
                            assetEntity,
                            isOriginal: false,
                          ),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
