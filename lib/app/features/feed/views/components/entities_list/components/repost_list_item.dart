// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/feed/data/models/repost_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_header/feed_item_reposted.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/router/app_routes.dart';

class RepostListItem extends StatelessWidget {
  const RepostListItem({required this.repost, super.key});

  final RepostEntity repost;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: repost.data.eventId, pubkey: repost.data.pubkey)
          .push<void>(context),
      child: ScreenSideOffset.small(
        child: Column(
          children: [
            FeedItemReposted(pubkey: repost.pubkey),
            Post(postId: repost.data.eventId, pubkey: repost.data.pubkey),
          ],
        ),
      ),
    );
  }
}
