// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/data/models/repost_data.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/repost/repost_header.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';

class Repost extends ConsumerWidget {
  const Repost({
    required this.repost,
    super.key,
  });

  final RepostEntity repost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity =
        ref.watch(nostrCacheProvider.select(cacheSelector<PostEntity>(repost.data.eventId)));

    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RepostHeader(pubkey: repost.pubkey),
          if (postEntity == null)
            const Skeleton(child: PostSkeleton())
          else
            Post(postEntity: postEntity),
        ],
      ),
    );
  }
}
