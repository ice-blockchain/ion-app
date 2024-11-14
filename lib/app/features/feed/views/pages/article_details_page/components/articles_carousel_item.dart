// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/feed/views/components/article/mocked_data.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_menu/feed_item_menu.dart';
import 'package:ion/app/features/feed/views/components/user_info/user_info.dart';

class ArticlesCarouselItem extends StatelessWidget {
  const ArticlesCarouselItem({required this.articleId, super.key});

  final String articleId;

  @override
  Widget build(BuildContext context) {
    final article = ArticleEntity.fromEventMessage(mockedArticleEvent);

    return Column(
      children: [
        UserInfo(
          pubkey: article.pubkey,
          trailing: Row(
            children: [
              FeedItemMenu(pubkey: article.pubkey),
            ],
          ),
        ),
      ],
    );
  }
}
