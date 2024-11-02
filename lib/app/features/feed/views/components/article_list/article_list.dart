// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/views/components/article_list/components/article_list_item.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({
    required this.articleIds,
    this.separator,
    super.key,
  });

  final List<String> articleIds;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: articleIds.length,
      separatorBuilder: (BuildContext context, int index) {
        return separator ?? FeedListSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        return ArticleListItem(articleId: articleIds[index]);
      },
    );
  }
}
