// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';

class ArticleListItem extends ConsumerWidget {
  const ArticleListItem({required this.articleId, super.key});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final article = ref.watch(nostrCacheProvider.select(cacheSelector<ArticleEntity>(articleId)));

    if (article == null) return const SizedBox.shrink();

    return GestureDetector(
      // onTap: () => ArticleDetailsRoute(articleId: articleId).push<void>(context),
      child: Article(article: article),
    );
  }
}
