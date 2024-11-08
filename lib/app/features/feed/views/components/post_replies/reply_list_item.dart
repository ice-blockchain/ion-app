// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_header/feed_item_header.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/router/app_routes.dart';

class ReplyListItem extends ConsumerWidget {
  const ReplyListItem({required this.reply, super.key});

  final PostEntity reply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: reply.id).push<void>(context),
      child: Post(header: FeedItemHeader(pubkey: reply.pubkey), postEntity: reply),
    );
  }
}
