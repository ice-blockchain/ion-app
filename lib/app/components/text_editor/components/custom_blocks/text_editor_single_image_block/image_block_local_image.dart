// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/gallery/providers/gallery_provider.r.dart';
import 'package:ion/app/services/media_service/aspect_ratio.dart';

class ImageBlockLocalImage extends HookConsumerWidget {
  const ImageBlockLocalImage({
    required this.path,
    super.key,
  });

  final String path;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = useState<File?>(null);
    final aspectRatio = useState<double?>(null);
    final isLoading = useState(true);

    useEffect(
      () {
        Future<void> loadImageData() async {
          try {
            final assetEntity = ref.read(assetEntityProvider(path)).valueOrNull;
            if (assetEntity != null) {
              aspectRatio.value = attachedMediaAspectRatio(
                [MediaAspectRatio.fromAssetEntity(assetEntity)],
              ).aspectRatio;

              file.value = await assetEntity.originFile;
            }
          } finally {
            if (context.mounted) {
              isLoading.value = false;
            }
          }
        }

        loadImageData();
        return null;
      },
      [path],
    );

    if (aspectRatio.value == null || isLoading.value || file.value == null) {
      return const SizedBox.shrink();
    }

    return AspectRatio(
      aspectRatio: aspectRatio.value!,
      child: Image.file(
        file.value!,
        fit: BoxFit.cover,
        width: double.infinity,
      ),
    );
  }
}
