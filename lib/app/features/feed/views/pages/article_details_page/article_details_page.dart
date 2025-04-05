// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/counter_items_footer/counter_items_footer.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/components/text_editor/text_editor_preview.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters.c.dart';
import 'package:ion/app/features/feed/views/components/deleted_entity/deleted_entity.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_date_topics.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_header.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_progress_indicator.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/article_details_topics.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/more_articles_from_author.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/more_articles_from_topic.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/components/user_biography.dart';
import 'package:ion/app/features/feed/views/pages/article_details_page/hooks/use_scroll_indicator.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/services/markdown/quill.dart';

class ArticleDetailsPage extends HookConsumerWidget {
  const ArticleDetailsPage({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleEntity =
        ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));

    if (articleEntity is! ArticleEntity) {
      return const SizedBox.shrink();
    }

    final scrollController = useScrollController();
    final progress = useScrollIndicator(scrollController);

    final delta = useMemoized(
      () => parseAndConvertDelta(
        articleEntity.data.richText?.content,
        articleEntity.data.content,
      ),
      [articleEntity.data.richText?.content, articleEntity.data.content],
    );

    final topics = articleEntity.data.topics;

    if (articleEntity.isDeleted) {
      DeletedEntity(entityType: DeletedEntityType.article);
    }

    return Scaffold(
      appBar: NavigationAppBar.screen(
        actions: [
          BookmarkButton(eventReference: eventReference),
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
                        publishedAt: articleEntity.data.publishedAt.value,
                        topics: topics,
                      ),
                    ),
                    SizedBox(height: 16.0.s),
                    if (articleEntity.isDeleted)
                      ScreenSideOffset.small(
                        child: DeletedEntity(entityType: DeletedEntityType.article),
                      )
                    else ...[
                      ArticleDetailsHeader(
                        article: articleEntity,
                      ),
                      if (articleEntity.data.content.isNotEmpty) SizedBox(height: 20.0.s),
                      ScreenSideOffset.small(
                        child: TextEditorPreview(
                          content: delta,
                          media: articleEntity.data.media,
                        ),
                      ),
                    ],
                    ScreenSideOffset.small(
                      child: CounterItemsFooter(eventReference: eventReference),
                    ),
                    FeedListSeparator(height: 8.0.s),
                    SizedBox(height: 20.0.s),
                    ScreenSideOffset.small(
                      child: UserBiography(eventReference: eventReference),
                    ),
                    if (topics != null && topics.isNotEmpty) ...[
                      SizedBox(height: 20.0.s),
                      ArticleDetailsTopics(topics: topics),
                    ],
                    MoreArticlesFromAuthor(eventReference: eventReference),
                    if (topics != null && topics.isNotEmpty)
                      MoreArticlesFromTopic(eventReference: eventReference, topic: topics.first),
                    ScreenBottomOffset(),
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
