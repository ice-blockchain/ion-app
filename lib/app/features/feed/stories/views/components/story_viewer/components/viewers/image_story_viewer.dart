// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/core/views/components/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.c.dart';

class ImageStoryViewer extends ConsumerWidget {
  const ImageStoryViewer({
    required this.path,
    required this.storyId,
    super.key,
  });

  final String path;
  final String storyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(storyImageCacheManagerProvider);

    return IonConnectNetworkImage(
      imageUrl: path,
      cacheManager: cacheManager,
      filterQuality: FilterQuality.high,
      progressIndicatorBuilder: (_, __, ___) => const CenteredLoadingIndicator(),
      imageBuilder: (context, imageProvider) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            ref.read(storyImageLoadStatusProvider(storyId).notifier).markLoaded();
          }
        });

        return DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
