// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';

class ArticleListItem extends ConsumerWidget {
  const ArticleListItem({required this.article, super.key});

  final ArticleEntity article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      // onTap: () => ArticleDetailsRoute(articleId: articleId).push<void>(context),
      child: Article(article: article),
    );
  }
}
