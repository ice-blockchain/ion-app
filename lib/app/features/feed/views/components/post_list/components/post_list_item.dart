// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/post_replies/post_replies.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.dart';

class PostListItem extends HookConsumerWidget {
  const PostListItem({required this.postId, super.key});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(nostrCacheProvider.select(cacheSelector<PostData>(postId)));
    final replyIds = ref.watch(postReplyIdsSelectorProvider(postId: postId));

    useOnInit(() {
      ref.read(postReplyIdsProvider.notifier).fetchReplies(postId: postId);
    });

    if (post == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: postId).push<void>(context),
      child: Post(
        postData: post,
        footer: Column(
          children: [
            PostFooter(postData: post),
            if (replyIds.isNotEmpty) PostReplies(postIds: replyIds),
          ],
        ),
      ),
    );
  }
}
