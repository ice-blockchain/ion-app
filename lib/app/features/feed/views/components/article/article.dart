// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_footer/article_footer.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/article_image.dart';
import 'package:ion/app/features/feed/views/components/article/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_header/feed_item_header.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_menu/feed_item_menu.dart';

class Article extends ConsumerWidget {
  const Article({
    required this.article,
    super.key,
  });

  final ArticleEntity article;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: context.theme.appColors.onPrimaryAccent,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0.s),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: 4.0.s,
                decoration: BoxDecoration(
                  color: context.theme.appColors.primaryAccent,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(4.0.s),
                    bottomRight: Radius.circular(4.0.s),
                  ),
                ),
              ),
              SizedBox(width: 12.0.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeedItemHeader(
                      pubkey: article.pubkey,
                      trailing: const Row(
                        children: [
                          BookmarkButton(id: 'test_article_id'),
                          FeedItemMenu(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0.s),
                    ArticleImage(
                      imageUrl: article.data.image,
                      minutesToRead: _calculateReadingTime(article.data.content),
                    ),
                    SizedBox(height: 10.0.s),
                    ArticleFooter(text: article.data.title ?? ''),
                  ],
                ),
              ),
              SizedBox(width: 16.0.s),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateReadingTime(String content) {
    const wordsPerMinute = 200;
    final words = content.split(' ').length;
    return (words / wordsPerMinute).ceil();
  }
}
