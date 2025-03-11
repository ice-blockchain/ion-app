// views/components/story_viewer/components/viewers/image_story_viewer.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
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

    return CachedNetworkImage(
      imageUrl: path,
      fit: BoxFit.cover,
      cacheManager: cacheManager,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholderFadeInDuration: Duration.zero,
      filterQuality: FilterQuality.high,
      progressIndicatorBuilder: (_, __, ___) => const CenteredLoadingIndicator(),
      errorWidget: (_, __, ___) => const SizedBox.shrink(),
      imageBuilder: (context, imageProvider) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // if (context.mounted) {
          ref.read(storyImagesLoadStatusControllerProvider.notifier).markLoaded(storyId);
          // }
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
