// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/load_more_builder.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/feed/providers/feed_user_interests_provider.c.dart';
import 'package:ion/app/features/feed/providers/topic_articles_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class ArticlesFromTopicPage extends ConsumerWidget {
  const ArticlesFromTopicPage({
    required this.topic,
    super.key,
  });

  final String topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(topicArticlesDataSourceProvider(topic));
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final entities = entitiesPagedData?.data.items;
    final availableSubcategories = ref.watch(
      feedUserInterestsProvider(FeedType.article)
          .select((state) => state.valueOrNull?.subcategories ?? {}),
    );
    final topicName = availableSubcategories[topic]?.display ?? topic;

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(topicName),
      ),
      body: LoadMoreBuilder(
        hasMore: entitiesPagedData?.hasMore ?? false,
        onLoadMore: ref.read(entitiesPagedDataProvider(dataSource).notifier).fetchEntities,
        slivers: [
          if (entities == null)
            const EntitiesListSkeleton()
          else
            EntitiesList(refs: entities.map((entity) => entity.toEventReference()).toList()),
        ],
      ),
    );
  }
}
