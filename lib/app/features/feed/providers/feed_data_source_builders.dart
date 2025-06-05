// SPDX-License-Identifier: ice License 1.0

import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event.c.dart';
import 'package:ion/app/features/ion_connect/model/related_event_marker.dart';
import 'package:ion/app/features/ion_connect/model/search_extension.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';

EntitiesDataSource buildArticlesDataSource({
  required ActionSource actionSource,
  required List<String> authors,
  required String currentPubkey,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
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
      if (searchExtensions != null) ...searchExtensions,
    ],
    currentPubkey: currentPubkey,
    forKind: ArticleEntity.kind,
  ).toString();

  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) {
      if (!authors.contains(entity.masterPubkey)) {
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
}

EntitiesDataSource buildVideosDataSource({
  required ActionSource actionSource,
  required List<String> authors,
  required String currentPubkey,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
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
        if (searchExtensions != null) ...searchExtensions,
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
        if (searchExtensions != null) ...searchExtensions,
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
      if (!authors.contains(entity.masterPubkey)) {
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
}

EntitiesDataSource buildPostsDataSource({
  required ActionSource actionSource,
  required List<String> authors,
  required String currentPubkey,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
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
        if (searchExtensions != null) ...searchExtensions,
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
        if (searchExtensions != null) ...searchExtensions,
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
        if (searchExtensions != null) ...searchExtensions,
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
      if (!authors.contains(entity.masterPubkey)) {
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
}

EntitiesDataSource buildStoriesDataSource({
  required ActionSource actionSource,
  required List<String> authors,
  required String currentPubkey,
  int limit = 1,
  List<SearchExtension>? searchExtensions,
  Map<String, List<String>>? tags,
}) {
  final search = SearchExtensions(
    [
      ReactionsSearchExtension(currentPubkey: currentPubkey),
      ReferencesSearchExtension(contain: false),
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

  return EntitiesDataSource(
    actionSource: actionSource,
    entityFilter: (entity) =>
        authors.contains(entity.masterPubkey) &&
        (entity is ModifiablePostEntity && entity.data.parentEvent == null),
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
}
