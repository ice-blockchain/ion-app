// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class ArticleListItem extends HookConsumerWidget {
  const ArticleListItem({required this.articleId, super.key});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(nostrCacheProvider.select(cacheSelector<ArticleEntity>(articleId)));
    // final replyIds = ref.watch(postReplyIdsSelectorProvider(postId: postId));

    useOnInit(() {
      // ref.read(postReplyIdsProvider.notifier).fetchReplies(postId: postId);
    });

    if (post == null) return const SizedBox.shrink();

    return GestureDetector(
      // onTap: () => PostDetailsRoute(postId: postId).push<void>(context),
      child: const SizedBox.shrink(),

      // // const Article(
      //     // postEntity: post,
      //     // footer: Column(
      //     //   children: [
      //     //     PostFooter(postEntity: post),
      //     //     if (replyIds.isNotEmpty) PostReplies(postIds: replyIds),
      //     //   ],
      //     // ),
      //     ),
    );
  }
}
