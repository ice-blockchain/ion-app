// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/related_hashtag.c.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/search/model/advanced_search_category.dart';
import 'package:ion/app/features/search/model/feed_search_source.dart';
import 'package:ion/app/features/search/providers/feed_search_filter_relays_provider.c.dart';
import 'package:ion/app/features/search/providers/feed_search_filters_provider.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/user_interests_set_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_search_posts_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedSearchPostsDataSource(
  Ref ref, {
  required String query,
  required AdvancedSearchCategory category,
}) {
  // TODO:pass languages to the filters when defined
  // ignore: unused_local_variable
  final languageInterestSet =
      ref.watch(currentUserInterestsSetProvider(InterestSetType.languages)).valueOrNull;
  final filters = ref.watch(feedSearchFilterProvider);
  final filterRelays = ref.watch(feedSearchFilterRelaysProvider(filters.source)).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  final isTagSearch = RelatedHashtag.isTag(query);

  final searchExtensions = [
    if (!isTagSearch) QuerySearchExtension(searchQuery: query),
    if (category == AdvancedSearchCategory.videos ||
        (!filters.categories[FeedCategory.feed].falseOrValue &&
            filters.categories[FeedCategory.videos].falseOrValue))
      VideosSearchExtension(contain: true),
    if (category == AdvancedSearchCategory.trending) TrendingSearchExtension(),
    if (category == AdvancedSearchCategory.top) TopSearchExtension(),
    if (category == AdvancedSearchCategory.photos) ImagesSearchExtension(contain: true),
  ];

  final tags = isTagSearch
      ? {
          // query.substring(1) is for backward compatibility - previously we set 't' tags without the symbol
          // it might be removed after the release
          '#${RelatedHashtag.tagName}': [query, query.substring(1)],
        }
      : <String, List<Object>>{};

  if (filterRelays != null && currentPubkey != null) {
    return [
      for (final entry in filterRelays.entries)
        _buildSearchDataSource(
          actionSource: ActionSourceRelayUrl(entry.key),
          authors: filters.source == FeedSearchSource.following ? entry.value : null,
          filters: _buildFilters(
            authors: filters.source == FeedSearchSource.following ? entry.value : null,
            currentPubkey: currentPubkey,
            tags: tags,
            searchExtensions: searchExtensions,
            includePosts: filters.categories[FeedCategory.feed].falseOrValue ||
                filters.categories[FeedCategory.videos].falseOrValue,
            includeArticles: filters.categories[FeedCategory.articles].falseOrValue,
          ),
        ),
    ];
  }
  return null;
}

EntitiesDataSource _buildSearchDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required List<RequestFilter> filters,
}) {
  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (authors != null && !authors.contains(entity.masterPubkey)) {
        return false;
      }

      return (entity is ModifiablePostEntity && entity.data.parentEvent == null) ||
          (entity is PostEntity && entity.data.parentEvent == null) ||
          entity is RepostEntity ||
          entity is GenericRepostEntity ||
          entity is ArticleEntity;
    },
    requestFilters: filters,
  );
}

List<RequestFilter> _buildFilters({
  required List<String>? authors,
  required String currentPubkey,
  required bool includePosts,
  required bool includeArticles,
  Map<String, List<Object?>> tags = const {},
  List<SearchExtension> searchExtensions = const [],
}) {
  final search = SearchExtensions([
    ...searchExtensions,
    if (includePosts) ...[
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
    ],
    if (includeArticles)
      ...SearchExtensions.withCounters(
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
      ).extensions,
  ]).toString();

  return [
    RequestFilter(
      kinds: [
        if (includePosts) ...[
          PostEntity.kind,
          ModifiablePostEntity.kind,
          RepostEntity.kind,
        ],
        if (includeArticles) ArticleEntity.kind,
      ],
      tags: tags,
      search: search,
      authors: authors,
      limit: 20,
    ),
    RequestFilter(
      kinds: const [GenericRepostEntity.kind],
      authors: authors,
      search: search,
      tags: {
        ...tags,
        '#k': [
          if (includePosts) ModifiablePostEntity.kind.toString(),
          if (includeArticles) ArticleEntity.kind.toString(),
        ],
      },
      limit: 20,
    ),
  ];
}
