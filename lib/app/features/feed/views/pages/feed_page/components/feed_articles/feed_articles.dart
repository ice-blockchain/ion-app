// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/article/feed_articles_ids_provider.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/views/components/article_list/article_list.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list_skeleton.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class FeedArticles extends HookConsumerWidget {
  const FeedArticles({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(feedCurrentFilterProvider);
    final articleIds = ref.watch(feedArticlesIdsProvider(filters: filters));

    useOnInit(
      () {
        ref.read(feedArticlesIdsProvider(filters: filters).notifier).fetchArticles();
      },
      [filters],
    );

    if (articleIds.isEmpty) {
      return const PostListSkeleton();
    }

    return ArticleList(articleIds: articleIds);
  }
}
