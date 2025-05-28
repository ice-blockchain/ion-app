// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/progress_bar/centered_loading_indicator.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/stories/providers/story_image_loading_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/quoted_event.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ImageStoryViewer extends ConsumerWidget {
  const ImageStoryViewer({
    required this.imageUrl,
    required this.authorPubkey,
    required this.storyId,
    this.quotedEvent,
    super.key,
  });

  final String imageUrl;
  final String authorPubkey;
  final String storyId;
  final QuotedEvent? quotedEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cacheManager = ref.watch(storyImageCacheManagerProvider);
    final hasQuotedPost = quotedEvent != null;

    final imageWidget = IonConnectNetworkImage(
      imageUrl: imageUrl,
      authorPubkey: authorPubkey,
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

    if (hasQuotedPost) {
      return GestureDetector(
        onTap: () {
          final eventReference = quotedEvent!.eventReference;
          PostDetailsRoute(
            eventReference: eventReference.encode(),
          ).push<void>(context);
        },
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
