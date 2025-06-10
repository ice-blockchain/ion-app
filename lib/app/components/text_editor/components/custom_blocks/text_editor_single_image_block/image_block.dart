// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/image_block_local_image.dart';
import 'package:ion/app/components/text_editor/components/custom_blocks/text_editor_single_image_block/image_block_network_image.dart';
import 'package:ion/app/features/ion_connect/data/models/media_attachment.dart';

class ImageBlock extends StatelessWidget {
  const ImageBlock({
    required this.path,
    super.key,
    this.media,
  });

  final String path;
  final Map<String, MediaAttachment>? media;

  bool get isNetworkImage => Uri.tryParse(path)?.hasAbsolutePath ?? false;

  @override
  Widget build(BuildContext context) {
    return isNetworkImage
        ? ImageBlockNetworkImage(path: path, media: media)
        : ImageBlockLocalImage(path: path);
  }
}
