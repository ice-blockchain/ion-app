// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/feed_category.dart';
import 'package:ion/app/features/feed/data/models/feed_filter.dart';
import 'package:ion/app/features/feed/providers/feed_current_filter_provider.c.dart';
import 'package:ion/app/features/feed/providers/feed_filter_relays_provider.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/entities_paged_data_models.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/interest_set.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/features/user/providers/user_interests_set_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_posts_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedPostsDataSource(Ref ref) {
  // TODO:pass languages to the filters when defined
  final languageInterestSet =
      ref.watch(currentUserInterestsSetProvider(InterestSetType.languages)).valueOrNull;
  final filters = ref.watch(feedCurrentFilterProvider);
  final filterRelays = ref.watch(feedFilterRelaysProvider).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays != null && currentPubkey != null && languageInterestSet != null) {
    return [
      for (final entry in filterRelays.entries)
        switch (filters.category) {
          FeedCategory.articles => _buildArticlesDataSource(
              actionSource: ActionSourceRelayUrl(entry.key),
              authors: filters.filter == FeedFilter.following ? entry.value : null,
              currentPubkey: currentPubkey,
            ),
          FeedCategory.videos => _buildVideosDataSource(
              actionSource: ActionSourceRelayUrl(entry.key),
              authors: filters.filter == FeedFilter.following ? entry.value : null,
              currentPubkey: currentPubkey,
            ),
          FeedCategory.feed => _buildPostsDataSource(
              actionSource: ActionSourceRelayUrl(entry.key),
              authors: filters.filter == FeedFilter.following ? entry.value : null,
              currentPubkey: currentPubkey,
            )
        },
    ];
  }
  return null;
}

EntitiesDataSource _buildArticlesDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required String currentPubkey,
}) {
  final search = SearchExtensions.withCounters(
    [
      GenericIncludeSearchExtension(
        forKind: ArticleEntity.kind,
        includeKind: UserMetadataEntity.kind,
      ),
      ProfileBadgesSearchExtension(forKind: ArticleEntity.kind),
      GenericIncludeSearchExtension(
        forKind: ArticleEntity.kind,
        includeKind: BlockListEntity.kind,
      ),
    ],
    currentPubkey: currentPubkey,
    forKind: ArticleEntity.kind,
  ).toString();

  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (authors != null && !authors.contains(entity.masterPubkey)) {
        return false;
      }

      return entity is ArticleEntity || entity is GenericRepostEntity;
    },
    requestFilters: [
      RequestFilter(
        kinds: const [ArticleEntity.kind],
        authors: authors,
        search: search,
        limit: 20,
      ),
      RequestFilter(
        kinds: const [GenericRepostEntity.kind],
        authors: authors,
        search: search,
        tags: {
          '#k': [ArticleEntity.kind.toString()],
        },
        limit: 20,
      ),
    ],
  );
}

EntitiesDataSource _buildVideosDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required String currentPubkey,
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
        ProfileBadgesSearchExtension(forKind: ModifiablePostEntity.kind),
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
        ProfileBadgesSearchExtension(forKind: PostEntity.kind),
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
    VideosSearchExtension(contain: true),
  ]).toString();

  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (authors != null && !authors.contains(entity.masterPubkey)) {
        return false;
      }

      return (entity is ModifiablePostEntity &&
              entity.data.parentEvent == null &&
              entity.data.quotedEvent == null) ||
          (entity is PostEntity &&
              entity.data.parentEvent == null &&
              entity.data.quotedEvent == null) ||
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

EntitiesDataSource _buildPostsDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required String currentPubkey,
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
        ProfileBadgesSearchExtension(forKind: ModifiablePostEntity.kind),
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
        ProfileBadgesSearchExtension(forKind: PostEntity.kind),
        GenericIncludeSearchExtension(
          forKind: PostEntity.kind,
          includeKind: BlockListEntity.kind,
        ),
      ],
      currentPubkey: currentPubkey,
      forKind: PostEntity.kind,
    ).extensions,
    ...SearchExtensions.withCounters(
      [
        GenericIncludeSearchExtension(
          forKind: ArticleEntity.kind,
          includeKind: UserMetadataEntity.kind,
        ),
        ProfileBadgesSearchExtension(forKind: ArticleEntity.kind),
        GenericIncludeSearchExtension(
          forKind: ArticleEntity.kind,
          includeKind: BlockListEntity.kind,
        ),
      ],
      currentPubkey: currentPubkey,
      forKind: ArticleEntity.kind,
    ).extensions,
    ReferencesSearchExtension(contain: false),
    ExpirationSearchExtension(expiration: false),
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
          entity is GenericRepostEntity ||
          entity is ArticleEntity;
    },
    requestFilters: [
      RequestFilter(
        kinds: const [
          PostEntity.kind,
          ModifiablePostEntity.kind,
          RepostEntity.kind,
          ArticleEntity.kind,
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
          '#k': [
            ModifiablePostEntity.kind.toString(),
            ArticleEntity.kind.toString(),
          ],
        },
        limit: 20,
      ),
    ],
  );
}
