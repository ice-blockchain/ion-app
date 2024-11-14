// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:ion/app/features/feed/providers/article_data_provider.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_details_action_button.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_footer.dart';
import 'package:ion/app/features/feed/views/components/text_editor/text_editor_preview.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_date_topics.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_header.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_section_header.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_topics.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/articles_carousel.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/user_biography.dart';
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
                SliverList(
                  delegate: SliverChildListDelegate([
                    ScreenSideOffset.small(
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
                    ArticleDetailsHeader(
                      article: articleEntity,
                    ),
                    ScreenSideOffset.small(child: const TextEditorPreview()),
                    const ArticleDetailsTopics(),
                    ScreenSideOffset.small(
                      child: FeedItemFooter(
                        entityId: articleEntity.id,
                        bottomPadding: 20.0.s,
                        actionBuilder: (context, child, onPressed) => FeedItemDetailsActionButton(
                          onPressed: onPressed,
                          child: child,
                        ),
                      ),
                    ),
                    ScreenSideOffset.small(
                      child: UserBiography(pubKey: articleEntity.pubkey),
                    ),
                    SizedBox(height: 16.0.s),
                    ScreenSideOffset.small(
                      child: ArticleDetailsSectionHeader(
                        title: context.i18n.article_page_from_author('Alicia Twen'),
                        count: 10,
                        trailing: GestureDetector(
                          onTap: () {},
                          child: Assets.svg.iconButtonNext.icon(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0.s),
                      child: const ArticlesCarousel(
                        articleIds: [
                          'fdsfds',
                          'fdsfdsfsdfsd',
                          'fdsfdsfsd',
                        ],
                      ),
                    ),
                    ScreenSideOffset.small(
                      child: ArticleDetailsSectionHeader(
                        title: ArticleTopic.values[0]
                            .toString(), //TODO: replace with first topic from articleEntity
                        count: 3,
                        trailing: GestureDetector(
                          onTap: () {},
                          child: Assets.svg.iconButtonNext.icon(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0.s),
                      child: const ArticlesCarousel(
                        articleIds: [
                          'fdsfds',
                          'fdsfdsfsdfsd',
                          'fdsfdsfsd',
                        ],
                      ),
                    ),
                  ]),
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
