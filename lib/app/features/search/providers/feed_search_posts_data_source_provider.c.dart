// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/features/search/providers/feed_search_filter_relays_provider.c.dart';
import 'package:ion/app/features/search/providers/feed_search_filters_provider.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_posts_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedSearchPostsDataSource(
  Ref ref, {
  required String query,
  required AdvancedSearchCategory category,
}) {
  final filters = ref.watch(feedSearchFilterProvider);
  final filterRelays = ref.watch(feedSearchFilterRelaysProvider(filters.source)).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  final searchExtensions = [
    QuerySearchExtension(searchQuery: query),
    if (category == AdvancedSearchCategory.videos ||
        (!filters.categories.contains(FeedCategory.feed) &&
            filters.categories.contains(FeedCategory.videos)))
      VideosSearchExtension(contain: true),
    if (category == AdvancedSearchCategory.trending) TrendingSearchExtension(),
    if (category == AdvancedSearchCategory.top) TopSearchExtension(),
    if (category == AdvancedSearchCategory.photos) ImagesSearchExtension(contain: true),
  ];

  if (filterRelays != null && currentPubkey != null) {
    return [
      for (final entry in filterRelays.entries)
        buildPostsDataSource(
          actionSource: ActionSourceRelayUrl(entry.key),
          authors: filters.source == FeedSearchSource.following ? entry.value : null,
          currentPubkey: currentPubkey,
          searchExtensions: searchExtensions,
        ),
    ];
  }
  return null;
}

EntitiesDataSource buildPostsDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required String currentPubkey,
  List<SearchExtension> searchExtensions = const [],
}) {
  final search = SearchExtensions([
    ...SearchExtensions.withCounters(
      [
        TagMarkerSearchExtension(
          tagName: RelatedReplaceableEvent.tagName,
          marker: RelatedEventMarker.reply.toShortString(),
          negative: true,
        ),
        GenericIncludeSearchExtension(
          forKind: ModifiablePostEntity.kind,
          includeKind: UserMetadataEntity.kind,
        ),
        GenericIncludeSearchExtension(
          forKind: ModifiablePostEntity.kind,
          includeKind: BlockListEntity.kind,
        ),
      ],
      currentPubkey: currentPubkey,
    ).extensions,
    ...SearchExtensions.withCounters(
      [
        TagMarkerSearchExtension(
          tagName: RelatedImmutableEvent.tagName,
          marker: RelatedEventMarker.reply.toShortString(),
          negative: true,
        ),
        GenericIncludeSearchExtension(
          forKind: PostEntity.kind,
          includeKind: UserMetadataEntity.kind,
        ),
        GenericIncludeSearchExtension(
          forKind: PostEntity.kind,
          includeKind: BlockListEntity.kind,
        ),
      ],
      currentPubkey: currentPubkey,
      forKind: PostEntity.kind,
    ).extensions,
    ReferencesSearchExtension(contain: false),
    ExpirationSearchExtension(expiration: false),
    ...searchExtensions,
  ]).toString();

  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (authors != null && !authors.contains(entity.masterPubkey)) {
        return false;
      }

      return (entity is ModifiablePostEntity && entity.data.parentEvent == null) ||
          (entity is PostEntity && entity.data.parentEvent == null) ||
          entity is RepostEntity ||
          entity is GenericRepostEntity;
    },
    requestFilters: [
      RequestFilter(
        kinds: const [
          PostEntity.kind,
          ModifiablePostEntity.kind,
          RepostEntity.kind,
        ],
        search: search,
        authors: authors,
        limit: 20,
      ),
      RequestFilter(
        kinds: const [GenericRepostEntity.kind],
        authors: authors,
        search: search,
        tags: {
          '#k': [ModifiablePostEntity.kind.toString()],
        },
        limit: 20,
      ),
    ],
  );
}
