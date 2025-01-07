// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/views/components/text_editor/text_editor_preview.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_date_topics.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_header.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_progress_indicator.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_section_header.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_topics.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/articles_carousel.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/user_biography.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/hooks/use_scroll_indicator.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/generated/assets.gen.dart';

class ArticleDetailsPage extends HookConsumerWidget {
  const ArticleDetailsPage({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleEntity = ref.watch(nostrEntityProvider(eventReference: eventReference)).valueOrNull
        as ArticleEntity?;

    if (articleEntity == null) {
      return const SizedBox.shrink();
    }

    final scrollController = useScrollController();
    final progress = useScrollIndicator(scrollController);

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
          ArticleDetailsProgressIndicator(progress: progress),
          Flexible(
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 13.0.s),
                    ScreenSideOffset.small(
                      child: ArticleDetailsDateTopics(
                        publishedAt: articleEntity.data.publishedAt,
                        topics: const [
                          'Technology',
                          'Crypto',
                        ], // TODO: get topics from articleEntity
                      ),
                    ),
                    SizedBox(height: 16.0.s),
                    ArticleDetailsHeader(
                      article: articleEntity,
                    ),
                    if (articleEntity.data.content.isNotEmpty) SizedBox(height: 20.0.s),
                    ScreenSideOffset.small(
                      child: TextEditorPreview(
                        content: articleEntity.data.content,
                        media: articleEntity.data.media,
                      ),
                    ),
                    const ArticleDetailsDateTopics(),
                    ScreenSideOffset.small(
                      child: CounterItemsFooter(
                        eventReference: eventReference,
                        bottomPadding: 10.0.s,
                        type: BookmarksSetType.articles,
                      ),
                    ),
                    Container(color: context.theme.appColors.primaryBackground, height: 8.0.s),
                    SizedBox(height: 20.0.s),
                    ScreenSideOffset.small(
                      child: UserBiography(pubkey: articleEntity.masterPubkey),
                    ),
                    SizedBox(height: 4.0.s),
                    const ArticleDetailsTopics(),
                    SizedBox(height: 4.0.s),
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
                        title: ArticleTopic
                            .values[0].name, // TODO: replace with first topic from articleEntity
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
