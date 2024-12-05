// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/entities_list/entities_list.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:ion/app/features/nostr/providers/mock_article_entities_paged_data_provider.dart';

class FeedPosts extends ConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedCategory = ref.watch(feedCurrentFilterProvider.select((state) => state.category));
    final dataSource = ref.watch(feedPostsDataSourceProvider);

    List<NostrEntity>? entities;

    // TODO: Remove this check and keep only entitiesPagedDataProvider when real data is available.
    if (feedCategory == FeedCategory.articles) {
      final mockedArticles = ref.watch(mockArticleEntitiesPagedDataProvider(dataSource));
      if (mockedArticles != null) {
        entities = mockedArticles;
      }
    } else {
      final entitiesPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
      if (entitiesPagedData?.data.items != null) {
        entities = entitiesPagedData?.data.items?.toList();
      }
    }

    if (entities == null || entities.isEmpty) {
      return const EntitiesListSkeleton();
    }

    return EntitiesList(
      entities: entities,
    );
  }
}
