// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/article_data_provider.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_footer/article_footer.dart';
import 'package:ion/app/features/feed/views/components/article/components/article_image/article_image.dart';
import 'package:ion/app/features/feed/views/components/article/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_header/feed_item_author.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_menu/feed_item_menu.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/utils/algorithm.dart';

class Article extends ConsumerWidget {
  const Article({
    required this.articleId,
    required this.pubkey,
    super.key,
  });

  final String articleId;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleEntity =
        ref.watch(articleDataProvider(articleId: articleId, pubkey: pubkey)).valueOrNull;

    if (articleEntity == null) {
      return const Skeleton(child: PostSkeleton());
    }

    return ColoredBox(
      color: context.theme.appColors.onPrimaryAccent,
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
                  FeedItemAuthor(
                    pubkey: pubkey,
                    trailing: Row(
                      children: [
                        const BookmarkButton(id: 'test_article_id'),
                        FeedItemMenu(pubkey: pubkey),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0.s),
                  ArticleImage(
                    imageUrl: articleEntity.data.image,
                    minutesToRead: calculateReadingTime(articleEntity.data.content),
                  ),
                  SizedBox(height: 10.0.s),
                  ArticleFooter(text: articleEntity.data.title ?? ''),
                ],
              ),
            ),
            SizedBox(width: 16.0.s),
          ],
        ),
      ),
    );
  }
}
