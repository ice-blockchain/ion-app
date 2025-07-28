// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.f.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/related_event.f.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.m.dart';
import 'package:ion/app/features/user/model/block_list.f.dart';
import 'package:ion/app/features/user/model/user_metadata.f.dart';

class FeedEntitiesDataSource {
  FeedEntitiesDataSource({
    required this.dataSource,
  });

  final EntitiesDataSource dataSource;

  List<IonConnectEntity> responseFilter(List<IonConnectEntity> entities) {
    final filtered = entities.where(dataSource.entityFilter).toList();

    // Handle the reposts corner case:
    //    A repost can be either a main event (current user or other user reposted something)
    //    or a dependency - repost from the current user in addition to some regular post.
    //    To handle it, we filter out reposts that have a reposted event in the same response.
    return filtered.where((entity) {
      final repostedReference = switch (entity) {
        GenericRepostEntity() => entity.data.eventReference,
        RepostEntity() => entity.data.eventReference,
        _ => null,
      };

      // If the entity is not a repost, we keep it.
      if (repostedReference == null) return true;

      // Check if there is a reposted event in the same response.
      final hasRepostedEvent =
          filtered.any((entity) => entity.toEventReference() == repostedReference);

      // If we found a reposted event, we filter out the repost, assuming that this is a dependency
      return !hasRepostedEvent;
    }).toList();
  }
}

FeedEntitiesDataSource buildArticlesDataSource({
  required ActionSource actionSource,
  required String currentPubkey,
  List<String>? authors,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
}) {
  final search = SearchExtensions([
    ...SearchExtensions.withCounters(currentPubkey: currentPubkey, forKind: ArticleEntity.kind)
        .extensions,
    ...SearchExtensions.withAuthors(forKind: ArticleEntity.kind).extensions,
    if (searchExtensions != null) ...searchExtensions,
  ]).toString();

  final dataSource = EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (authors != null && !authors.contains(entity.masterPubkey)) {
        return false;
      }

      return entity is ArticleEntity || entity is GenericRepostEntity;
    },
    requestFilters: [
      RequestFilter(
        kinds: const [
          ArticleEntity.kind,
          GenericRepostEntity.articleRepostKind,
        ],
        authors: authors,
        limit: limit,
        tags: tags,
        search: search,
      ),
    ],
  );

  return FeedEntitiesDataSource(dataSource: dataSource);
}

FeedEntitiesDataSource buildVideosDataSource({
  required ActionSource actionSource,
  required String currentPubkey,
  List<String>? authors,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
}) {
  final search = SearchExtensions([
    ...SearchExtensions.withCounters(currentPubkey: currentPubkey).extensions,
    ...SearchExtensions.withAuthors().extensions,
    ...SearchExtensions.withCounters(currentPubkey: currentPubkey, forKind: PostEntity.kind)
        .extensions,
    ...SearchExtensions.withAuthors(forKind: PostEntity.kind).extensions,
    ReferencesSearchExtension(contain: false),
    ExpirationSearchExtension(expiration: false),
    VideosSearchExtension(contain: true),
    TagMarkerSearchExtension(
      tagName: RelatedReplaceableEvent.tagName,
      marker: RelatedEventMarker.reply.toShortString(),
      negative: true,
    ),
    TagMarkerSearchExtension(
      tagName: RelatedImmutableEvent.tagName,
      marker: RelatedEventMarker.reply.toShortString(),
      negative: true,
    ),
    if (searchExtensions != null) ...searchExtensions,
  ]).toString();

  final dataSource = EntitiesDataSource(
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
          GenericRepostEntity.modifiablePostRepostKind,
        ],
        search: search,
        authors: authors,
        limit: limit,
        tags: tags,
      ),
    ],
  );

  return FeedEntitiesDataSource(dataSource: dataSource);
}

FeedEntitiesDataSource buildPostsDataSource({
  required ActionSource actionSource,
  required String currentPubkey,
  List<String>? authors,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
}) {
  final search = SearchExtensions([
    ...SearchExtensions.withCounters(currentPubkey: currentPubkey).extensions,
    ...SearchExtensions.withAuthors().extensions,
    ...SearchExtensions.withCounters(currentPubkey: currentPubkey, forKind: PostEntity.kind)
        .extensions,
    ...SearchExtensions.withAuthors(forKind: PostEntity.kind).extensions,
    ...SearchExtensions.withCounters(currentPubkey: currentPubkey, forKind: ArticleEntity.kind)
        .extensions,
    ...SearchExtensions.withAuthors(forKind: ArticleEntity.kind).extensions,
    ReferencesSearchExtension(contain: false),
    ExpirationSearchExtension(expiration: false),
    TagMarkerSearchExtension(
      tagName: RelatedReplaceableEvent.tagName,
      marker: RelatedEventMarker.reply.toShortString(),
      negative: true,
    ),
    TagMarkerSearchExtension(
      tagName: RelatedImmutableEvent.tagName,
      marker: RelatedEventMarker.reply.toShortString(),
      negative: true,
    ),
    if (searchExtensions != null) ...searchExtensions,
  ]).toString();

  final dataSource = EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (IonConnectEntity entity) {
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
          GenericRepostEntity.modifiablePostRepostKind,
          GenericRepostEntity.articleRepostKind,
        ],
        search: search,
        authors: authors,
        limit: limit,
        tags: tags,
      ),
    ],
  );

  return FeedEntitiesDataSource(dataSource: dataSource);
}

FeedEntitiesDataSource buildStoriesDataSource({
  required ActionSource actionSource,
  required String currentPubkey,
  List<String>? authors,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
}) {
  final search = SearchExtensions(
    [
      ReactionsSearchExtension(currentPubkey: currentPubkey),
      ExpirationSearchExtension(expiration: true),
      MediaSearchExtension(contain: true),
      GenericIncludeSearchExtension(
        forKind: ModifiablePostEntity.kind,
        includeKind: UserMetadataEntity.kind,
      ),
      ProfileBadgesSearchExtension(forKind: ModifiablePostEntity.kind),
      GenericIncludeSearchExtension(
        forKind: ModifiablePostEntity.kind,
        includeKind: BlockListEntity.kind,
      ),
      if (searchExtensions != null) ...searchExtensions,
    ],
  ).toString();

  final dataSource = EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) =>
        (authors == null || authors.contains(entity.masterPubkey)) &&
        (entity is ModifiablePostEntity &&
            entity.data.parentEvent == null &&
            entity.data.expiration != null),
    requestFilters: [
      RequestFilter(
        kinds: const [ModifiablePostEntity.kind],
        authors: authors,
        limit: limit,
        search: search,
        tags: tags,
      ),
    ],
  );

  return FeedEntitiesDataSource(dataSource: dataSource);
}
