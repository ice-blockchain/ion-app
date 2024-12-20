// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
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
import 'package:ion/app/features/nostr/model/related_event.c.dart';
import 'package:ion/app/features/nostr/model/search_extension.dart';
import 'package:ion/app/features/nostr/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_posts_data_source_provider.c.g.dart';

@riverpod
List<EntitiesDataSource>? feedPostsDataSource(Ref ref) {
  final filters = ref.watch(feedCurrentFilterProvider);
  final filterRelays = ref.watch(feedFilterRelaysProvider(filters.filter)).valueOrNull;
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (filterRelays != null && currentPubkey != null) {
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
      ReferencesSearchExtension(contain: false),
      ExpirationSearchExtension(expiration: false),
      TagMarkerSearchExtension(
        tagName: RelatedEvent.tagName,
        marker: RelatedEventMarker.reply.toShortString(),
        negative: true,
      ),
      GenericIncludeSearchExtension(
        forKind: ArticleEntity.kind,
        includeKind: UserMetadataEntity.kind,
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
        limit: 10,
      ),
      RequestFilter(
        kinds: const [GenericRepostEntity.kind],
        authors: authors,
        search: search,
        k: [ArticleEntity.kind.toString()],
        limit: 10,
      ),
    ],
  );
}

EntitiesDataSource _buildVideosDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required String currentPubkey,
}) {
  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (authors != null && !authors.contains(entity.masterPubkey)) {
        return false;
      }

      return (entity is PostEntity &&
              entity.data.parentEvent == null &&
              entity.data.quotedEvent == null) ||
          entity is RepostEntity;
    },
    requestFilters: [
      RequestFilter(
        kinds: const [PostEntity.kind, RepostEntity.kind],
        search: SearchExtensions.withCounters(
          [
            ReferencesSearchExtension(contain: false),
            ExpirationSearchExtension(expiration: false),
            VideosSearchExtension(contain: true),
            TagMarkerSearchExtension(
              tagName: RelatedEvent.tagName,
              marker: RelatedEventMarker.reply.toShortString(),
              negative: true,
            ),
            GenericIncludeSearchExtension(
              forKind: PostEntity.kind,
              includeKind: UserMetadataEntity.kind,
            ),
          ],
          currentPubkey: currentPubkey,
        ).toString(),
        authors: authors,
        limit: 10,
      ),
    ],
  );
}

EntitiesDataSource _buildPostsDataSource({
  required ActionSource actionSource,
  required List<String>? authors,
  required String currentPubkey,
}) {
  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (authors != null && !authors.contains(entity.masterPubkey)) {
        return false;
      }

      return (entity is PostEntity && entity.data.parentEvent == null) || entity is RepostEntity;
    },
    requestFilters: [
      RequestFilter(
        kinds: const [PostEntity.kind, RepostEntity.kind],
        search: SearchExtensions.withCounters(
          [
            ReferencesSearchExtension(contain: false),
            ExpirationSearchExtension(expiration: false),
            TagMarkerSearchExtension(
              tagName: RelatedEvent.tagName,
              marker: RelatedEventMarker.reply.toShortString(),
              negative: true,
            ),
            GenericIncludeSearchExtension(
              forKind: PostEntity.kind,
              includeKind: UserMetadataEntity.kind,
            ),
          ],
          currentPubkey: currentPubkey,
        ).toString(),
        authors: authors,
        limit: 10,
      ),
    ],
  );
}
