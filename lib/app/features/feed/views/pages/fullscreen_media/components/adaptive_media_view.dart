// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/core/model/media_type.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/pages/fullscreen_media/components/fullscreen_image.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/media_attachment.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/video/views/pages/video_page.dart';

class AdaptiveMediaView extends HookConsumerWidget {
  const AdaptiveMediaView({
    required this.eventReference,
    required this.initialMediaIndex,
    super.key,
  });

  final EventReference eventReference;
  final int initialMediaIndex;

  static List<MediaAttachment> _filterKnownMedia(List<MediaAttachment> media) {
    return media.where((mediaItem) => mediaItem.mediaType != MediaType.unknown).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(ionConnectEntityProvider(eventReference: eventReference));

    return postAsync.maybeWhen(
      data: (post) {
        if (post is! ModifiablePostEntity) {
          return const SizedBox.shrink();
        }

        final allMedia = _filterKnownMedia(post.data.media.values.toList());

        if (allMedia.isEmpty) {
          return const SizedBox.shrink();
        }

        final currentIndex = initialMediaIndex.clamp(0, allMedia.length - 1);
        final initialMedia = allMedia[currentIndex];
        final isVideo = initialMedia.mediaType == MediaType.video;

        final videoMedia = allMedia.where((m) => m.mediaType == MediaType.video).toList();
        final imageMedia = allMedia.where((m) => m.mediaType == MediaType.image).toList();

        final currentMediaList = isVideo ? videoMedia : imageMedia;

        if (currentMediaList.length <= 1) {
          return _buildSingleMediaView(context, post, initialMedia);
        }

        final startingIndex = currentMediaList.indexWhere((m) => m.url == initialMedia.url);
        final pageController =
            usePageController(initialPage: startingIndex >= 0 ? startingIndex : 0);

        return isVideo
            ? _buildVerticalVideoCarousel(context, post, videoMedia, pageController)
            : _buildHorizontalImageCarousel(context, imageMedia, pageController);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildSingleMediaView(
    BuildContext context,
    ModifiablePostEntity post,
    MediaAttachment media,
  ) {
    if (media.mediaType == MediaType.video) {
      return VideoPage(
        video: post,
        eventReference: eventReference,
      );
    } else {
      return FullscreenImage(
        imageUrl: media.url,
        eventReference: eventReference,
      );
    }
  }

  Widget _buildVerticalVideoCarousel(
    BuildContext context,
    ModifiablePostEntity post,
    List<MediaAttachment> videos,
    PageController controller,
  ) {
    return PageView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final videoMedia = videos[index];

        return VideoPage(
          video: post.copyWith(
            data: post.data.copyWith(
              media: {videoMedia.url: videoMedia},
            ),
          ),
          eventReference: eventReference,
          onVideoEnded: () => controller.nextPage(
            duration: 300.ms,
            curve: Curves.easeInOut,
          ),
        );
      },
    );
  }

  Widget _buildHorizontalImageCarousel(
    BuildContext context,
    List<MediaAttachment> images,
    PageController controller,
  ) {
    return PageView.builder(
      controller: controller,
      itemCount: images.length,
      itemBuilder: (context, index) {
        return FullscreenImage(
          imageUrl: images[index].url,
          eventReference: eventReference,
        );
      },
    );
  }
}
