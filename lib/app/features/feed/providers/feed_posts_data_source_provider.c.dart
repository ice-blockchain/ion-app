// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_posts_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedPostsDataSource(Ref ref) {
  final filters = ref.watch(feedCurrentFilterProvider);
  final filterRelays = ref.watch(feedFilterRelaysProvider(filters.filter)).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays != null) {
    return [
      for (final entry in filterRelays.entries)
        switch (filters.category) {
          FeedCategory.articles => _buildArticlesDataSource(
              actionSource: ActionSourceRelayUrl(entry.key),
              authors: filters.filter == FeedFilter.following ? entry.value : null,
            ),
          FeedCategory.videos => _buildPostsDataSource(
              actionSource: ActionSourceRelayUrl(entry.key),
              authors: [currentPubkey!], //TODO: temp for debug
            ),
          FeedCategory.feed => _buildPostsDataSource(
              actionSource: ActionSourceRelayUrl(entry.key),
              authors: filters.filter == FeedFilter.following ? entry.value : null,
            )
        },
    ];
  }
  return null;
}

EntitiesDataSource _buildArticlesDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
}) {
  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) => entity is ArticleEntity || entity is GenericRepostEntity,
    requestFilters: [
      RequestFilter(
        kinds: const [ArticleEntity.kind],
        authors: authors,
        limit: 10,
      ),
      RequestFilter(
        kinds: const [GenericRepostEntity.kind],
        authors: authors,
        k: [ArticleEntity.kind.toString()],
        limit: 10,
      ),
    ],
  );
}

EntitiesDataSource _buildPostsDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
}) {
  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) => entity is PostEntity || entity is RepostEntity,
    requestFilters: [
      RequestFilter(
        kinds: const [PostEntity.kind, RepostEntity.kind],
        search:
            'include:dependencies:kind1>kind6400+kind1+group+root include:dependencies:kind1>kind6400+kind6+group+e include:dependencies:kind1>kind6400+kind1+group+q include:dependencies:kind1>kind6400+kind7+group+content',
        authors: authors,
        limit: 10,
      ),
    ],
  );
}
