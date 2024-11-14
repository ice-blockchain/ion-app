// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/article_data_provider.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_details_action_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_date_topics.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_header.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_topics.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticleDetailsPage extends ConsumerWidget {
  const ArticleDetailsPage({
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
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: NavigationAppBar.screen(
        actions: [
          IconButton(
            icon: Assets.svg.iconBookmarks.icon(
              size: NavigationAppBar.actionButtonSide,
              color: context.theme.appColors.primaryText,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ScreenSideOffset.small(
                    child: Padding(
                      padding: EdgeInsets.only(top: 13.0.s, bottom: 16.0.s),
                      child: ArticleDetailsDateTopics(
                        publishedAt: articleEntity.data.publishedAt,
                        topics: const [
                          'Technology',
                          'Crypto',
                        ], //TODO: get topics from articleEntity
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ArticleDetailsHeader(
                    article: articleEntity,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.green,
                    height: 200,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: ArticleDetailsTopics(),
                ),
                SliverToBoxAdapter(
                  child: ScreenSideOffset.small(
                    child: FeedItemFooter(
                      entityId: articleEntity.id,
                      bottomPadding: 12.0.s,
                      actionBuilder: (context, child, onPressed) => FeedItemDetailsActionButton(
                        onPressed: onPressed,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const HorizontalSeparator(),
        ],
      ),
    );
  }
}
