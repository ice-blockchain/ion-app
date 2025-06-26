// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.m.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.r.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'topic_articles_data_source_provider.r.g.dart';

@riverpod
List<EntitiesDataSource>? topicArticlesDataSource(Ref ref, String topic) {
  final filter = ref.watch(feedCurrentFilterProvider.select((state) => state.filter));
  final filterRelays = ref.watch(feedFilterRelaysProvider).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays != null && currentPubkey != null) {
    return [
      for (final entry in filterRelays.entries)
        _buildArticlesDataSource(
          actionSource: ActionSourceRelayUrl(entry.key),
          authors: filter == FeedFilter.following ? entry.value : null,
          currentPubkey: currentPubkey,
          topic: topic,
        ),
    ];
  }
  return null;
}

EntitiesDataSource _buildArticlesDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required String currentPubkey,
  required String topic,
}) {
  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) => entity is ArticleEntity,
    requestFilters: [
      RequestFilter(
        kinds: const [ArticleEntity.kind],
        authors: authors,
        search: SearchExtensions([
          ...SearchExtensions.withCounters(
            currentPubkey: currentPubkey,
            forKind: ArticleEntity.kind,
          ).extensions,
          ...SearchExtensions.withAuthors(forKind: ArticleEntity.kind).extensions,
        ]).toString(),
        limit: 20,
        tags: {
          '#t': [topic],
        },
      ),
    ],
  );
}
