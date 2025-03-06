// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/extensions/extensions.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(ionConnectEntityProvider(eventReference: eventReference));

    return postAsync.maybeWhen(
      data: (post) {
        if (post is! ModifiablePostEntity) {
          return const SizedBox.shrink();
        }

        return _MediaContentHandler(
          post: post,
          eventReference: eventReference,
          initialMediaIndex: initialMediaIndex,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _MediaContentHandler extends HookConsumerWidget {
  const _MediaContentHandler({
    required this.post,
    required this.eventReference,
    required this.initialMediaIndex,
  });

  final ModifiablePostEntity post;
  final EventReference eventReference;
  final int initialMediaIndex;

  static List<MediaAttachment> _filterKnownMedia(List<MediaAttachment> media) {
    return media.where((mediaItem) => mediaItem.mediaType != MediaType.unknown).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allMedia = _filterKnownMedia(post.data.media.values.toList());

    if (allMedia.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentIndex = initialMediaIndex.clamp(0, allMedia.length - 1);
    final selectedMedia = allMedia[currentIndex];

    final isVideoSelected = selectedMedia.mediaType == MediaType.video;

    final filteredMedia =
        allMedia.where((media) => media.mediaType == selectedMedia.mediaType).toList();

    if (filteredMedia.length <= 1) {
      return _SingleMediaView(
        post: post,
        media: selectedMedia,
        eventReference: eventReference,
      );
    }

    final filteredIndex = filteredMedia.indexWhere((media) => media.url == selectedMedia.url);
    final startIndex = filteredIndex >= 0 ? filteredIndex : 0;

    return isVideoSelected
        ? _VideoCarousel(
            post: post,
            videos: filteredMedia,
            initialIndex: startIndex,
            eventReference: eventReference,
          )
        : _ImageCarousel(
            images: filteredMedia,
            initialIndex: startIndex,
            eventReference: eventReference,
          );
  }
}

class _SingleMediaView extends StatelessWidget {
  const _SingleMediaView({
    required this.post,
    required this.media,
    required this.eventReference,
  });

  final ModifiablePostEntity post;
  final MediaAttachment media;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return media.mediaType == MediaType.video
        ? VideoPage(
            video: post,
            eventReference: eventReference,
            looping: true,
          )
        : FullscreenImage(
            imageUrl: media.url,
            eventReference: eventReference,
          );
  }
}

class _VideoCarousel extends HookWidget {
  const _VideoCarousel({
    required this.post,
    required this.videos,
    required this.initialIndex,
    required this.eventReference,
  });

  final ModifiablePostEntity post;
  final List<MediaAttachment> videos;
  final int initialIndex;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: initialIndex);
    final currentPage = useState(initialIndex);

    useEffect(
      () {
        void listener() {
          if (pageController.page != null) {
            currentPage.value = pageController.page!.round();
          }
        }

        pageController.addListener(listener);
        return () => pageController.removeListener(listener);
      },
      [pageController],
    );

    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return VideoPage(
          key: ValueKey('video_${videos[index].url}'),
          video: post,
          eventReference: eventReference,
          videoUrl: videos[index].url,
          onVideoEnded: () {
            final nextPage = (index + 1) % videos.length;
            pageController.animateToPage(
              nextPage,
              duration: 300.ms,
              curve: Curves.easeInOut,
            );
          },
        );
      },
    );
  }
}

class _ImageCarousel extends HookWidget {
  const _ImageCarousel({
    required this.images,
    required this.initialIndex,
    required this.eventReference,
  });

  final List<MediaAttachment> images;
  final int initialIndex;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(initialPage: initialIndex);

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: pageController,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return FullscreenImage(
                imageUrl: images[index].url,
                eventReference: eventReference,
              );
            },
          ),
        ),
        SizedBox(height: 20.0.s),
        ColoredBox(
          color: context.theme.appColors.primaryText,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: SafeArea(
              top: false,
              child: CounterItemsFooter(
                eventReference: eventReference,
                color: context.theme.appColors.onPrimaryAccent,
                bottomPadding: 0,
                topPadding: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
