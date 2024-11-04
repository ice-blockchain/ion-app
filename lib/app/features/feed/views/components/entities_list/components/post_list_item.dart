// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/providers/post_replies_provider.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/post_replies/post_replies_list.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.dart';

class PostListItem extends HookConsumerWidget {
  const PostListItem({required this.post, super.key});

  final PostEntity post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final replies = ref.watch(postRepliesSelectorProvider(postId: post.id));

    useOnInit(() {
      ref.read(postRepliesProvider.notifier).fetchReplies(postId: post.id);
    });

    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: post.id).push<void>(context),
      child: Post(
        postEntity: post,
        footer: Column(
          children: [
            FeedItemFooter(postEntity: post),
            if (replies.isNotEmpty) PostRepliesList(replies: replies),
          ],
        ),
      ),
    );
  }
}
