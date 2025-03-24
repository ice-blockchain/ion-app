// SPDX-License-Identifier: ice License 1.0

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_author.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_likes_button.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_menu_button.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class TrendingVideoListItem extends ConsumerWidget {
  const TrendingVideoListItem({
    required this.video,
    required this.itemSize,
    super.key,
  });

  final ModifiablePostEntity video;
  final Size itemSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventReference = video.toEventReference();

    final thumbnailUrl = video.data.primaryVideo?.thumb;
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return _PlaceholderThumbnail(size: itemSize);
    }

    return GestureDetector(
      onTap: () {
        TrendingVideosRoute(
          eventReference: eventReference.encode(),
        ).push<void>(context);
      },
      child: _VideoContainer(
        thumbnailUrl: thumbnailUrl,
        size: itemSize,
        eventReference: eventReference,
      ),
    );
  }
}

class _PlaceholderThumbnail extends StatelessWidget {
  const _PlaceholderThumbnail({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        color: context.theme.appColors.sheetLine.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Center(
        child: Icon(
          Icons.broken_image,
          size: 48.0.s,
          color: context.theme.appColors.sheetLine,
        ),
      ),
    );
  }
}

class _VideoContainer extends StatelessWidget {
  const _VideoContainer({
    required this.thumbnailUrl,
    required this.size,
    required this.eventReference,
  });

  final String thumbnailUrl;
  final Size size;
  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0.s),
        image: DecorationImage(
          image: CachedNetworkImageProvider(thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TopControls(eventReference: eventReference),
          TrendingVideoAuthor(pubkey: eventReference.pubkey),
        ],
      ),
    );
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0.s,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TrendingVideoLikesButton(eventReference: eventReference),
          TrendingVideoMenuButton(onPressed: () {}),
        ],
      ),
    );
  }
}
