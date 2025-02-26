// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/article_topic.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'topic_articles_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? topicArticlesDataSource(Ref ref, ArticleTopic topic) {
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
  required ArticleTopic topic,
}) {
  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) => entity is ArticleEntity,
    requestFilters: [
      RequestFilter(
        kinds: const [ArticleEntity.kind],
        authors: authors,
        search: SearchExtensions.withCounters(
          [
            GenericIncludeSearchExtension(
              forKind: ArticleEntity.kind,
              includeKind: UserMetadataEntity.kind,
            ),
            GenericIncludeSearchExtension(
              forKind: ArticleEntity.kind,
              includeKind: BlockListEntity.kind,
            ),
          ],
          currentPubkey: currentPubkey,
          forKind: ArticleEntity.kind,
        ).toString(),
        limit: 20,
        tags: {
          '#t': [topic.toShortString()],
        },
      ),
    ],
  );
}
