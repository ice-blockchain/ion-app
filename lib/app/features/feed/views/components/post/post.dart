// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/features/feed/providers/post_data_provider.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_body/post_body.dart';
import 'package:ion/app/features/feed/views/components/post/components/quoted_post_frame/quoted_post_frame.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';
import 'package:ion/app/features/feed/views/components/user_info_menu/user_info_menu.dart';

class Post extends ConsumerWidget {
  const Post({
    required this.postId,
    required this.pubkey,
    this.header,
    this.footer,
    super.key,
  });

  final String postId;
  final String pubkey;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity = ref.watch(postDataProvider(postId: postId, pubkey: pubkey)).valueOrNull;

    if (postEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    final quotedEvent = postEntity.data.quotedEvent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header ??
            UserInfo(
              pubkey: pubkey,
              trailing: UserInfoMenu(pubkey: pubkey),
            ),
        PostBody(postEntity: postEntity),
        if (quotedEvent != null)
          QuotedPostFrame(
            child: Post(
              postId: quotedEvent.eventId,
              pubkey: quotedEvent.pubkey,
              header: UserInfo(pubkey: quotedEvent.pubkey),
              footer: const SizedBox.shrink(),
            ),
          ),
        footer ?? FeedItemFooter(entityId: postId),
      ],
    );
  }
}
