// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/models/article/article_data.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_posts_data_source_provider.g.dart';

@riverpod
List<EntitiesDataSource>? feedPostsDataSource(Ref ref) {
  final filters = ref.watch(feedCurrentFilterProvider);
  final filterRelays = ref.watch(feedFilterRelaysProvider(filters.filter)).valueOrNull;

  if (filterRelays != null) {
    final dataSources = filterRelays.entries
        .map(
          (entry) => EntitiesDataSource(
            actionSource: ActionSourceRelayUrl(entry.key),
            entityFilter: (entity) => entity is PostEntity || entity is ArticleEntity,
            requestFilter: RequestFilter(
              kinds: filters.category == FeedCategory.articles
                  ? const [ArticleEntity.kind]
                  : const [PostEntity.kind],
              authors: filters.filter == FeedFilter.following ? entry.value : null,
              limit: 10,
            ),
          ),
        )
        .toList();

    return dataSources;
  }
  return null;
}
