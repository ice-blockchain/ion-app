// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_network_image/ion_connect_network_image.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/views/components/overlay_menu/user_info_menu.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_author.dart';
import 'package:ion/app/features/feed/views/pages/feed_page/components/trending_videos/components/trending_video_likes_button.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/user/providers/muted_users_notifier.c.dart';
import 'package:ion/app/features/user_block/providers/block_list_notifier.c.dart';
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
    if (_isBlockedOrMutedOrBlocking(ref, video)) {
      return const SizedBox.shrink();
    }

    final eventReference = video.toEventReference();

    final thumbnailUrl = video.data.primaryVideo?.thumb;
    if (thumbnailUrl == null || thumbnailUrl.isEmpty) {
      return _PlaceholderThumbnail(size: itemSize);
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(end: 12.0.s),
      child: GestureDetector(
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
      ),
    );
  }

  bool _isBlockedOrMutedOrBlocking(WidgetRef ref, IonConnectEntity entity) {
    final isMuted = ref.watch(isUserMutedProvider(entity.masterPubkey));
    final isBlockedOrBlockedBy =
        ref.watch(isEntityBlockedOrBlockedByNotifierProvider(entity)).valueOrNull ?? false;
    return isMuted || isBlockedOrBlockedBy;
  }
}

class _PlaceholderThumbnail extends StatelessWidget {
  const _PlaceholderThumbnail({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 12.0.s),
      child: Container(
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
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0.s),
        child: Stack(
          fit: StackFit.expand,
          children: [
            IonConnectNetworkImage(
              imageUrl: thumbnailUrl,
              authorPubkey: eventReference.pubkey,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TopControls(eventReference: eventReference),
                TrendingVideoAuthor(pubkey: eventReference.pubkey),
              ],
            ),
          ],
        ),
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
          UserInfoMenu(
            showShadow: true,
            iconSize: 16.0.s,
            eventReference: eventReference,
            iconColor: context.theme.appColors.onPrimaryAccent,
            padding: EdgeInsetsDirectional.only(end: 6.0.s, top: 12.0.s),
          ),
        ],
      ),
    );
  }
}
