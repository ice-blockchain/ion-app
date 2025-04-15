// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.c.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';

class ImageBlockLocalImage extends ConsumerStatefulWidget {
  const ImageBlockLocalImage({
    required this.path,
    super.key,
  });

  final String path;

  @override
  ConsumerState<ImageBlockLocalImage> createState() => _ImageBlockLocalImageState();
}

class _ImageBlockLocalImageState extends ConsumerState<ImageBlockLocalImage>
    with AutomaticKeepAliveClientMixin {
  File? _file;
  double? _aspectRatio;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImageData();
  }

  Future<void> _loadImageData() async {
    try {
      final assetEntity = ref.read(assetEntityProvider(widget.path)).valueOrNull;
      if (assetEntity != null) {
        _aspectRatio = attachedMediaAspectRatio(
          [MediaAspectRatio.fromAssetEntity(assetEntity)],
        ).aspectRatio;

        _file = await assetEntity.originFile;
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_aspectRatio == null || _isLoading || _file == null) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: _aspectRatio!,
      child: Image.file(
        _file!,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
