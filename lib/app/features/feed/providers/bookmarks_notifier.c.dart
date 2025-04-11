// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_notifier.c.g.dart';

@immutable
class BookmarkTypes {
  const BookmarkTypes(this.types);

  final List<BookmarksSetType> types;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkTypes && const ListEquality<BookmarksSetType>().equals(types, other.types);

  @override
  int get hashCode => const ListEquality<BookmarksSetType>().hash(types);
}

@riverpod
Future<Map<BookmarksSetType, BookmarksSetEntity?>> bookmarks(
  Ref ref,
  String pubkey,
  BookmarkTypes bookmarkTypes,
) async {
  final bookmarkTypesList = bookmarkTypes.types;
  final bookmarksMap = Map.fromEntries(
    bookmarkTypesList.map((type) {
      final cacheKey = CacheableEntity.cacheKeyBuilder(
        eventReference: ReplaceableEventReference(
          pubkey: pubkey,
          kind: BookmarksSetEntity.kind,
          dTag: type.dTagName,
        ),
      );
      final bookmarkSet = ref.watch(
        ionConnectCacheProvider.select(cacheSelector<BookmarksSetEntity>(cacheKey)),
      );
      return MapEntry(type, bookmarkSet);
    }),
  );

  if (bookmarksMap.values.any((bookmarksSet) => bookmarksSet != null)) {
    return bookmarksMap;
  }

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [BookmarksSetEntity.kind],
        tags: {
          '#d': bookmarkTypesList.map((type) => type.dTagName).toList(),
        },
        authors: [pubkey],
      ),
    );

  final eventsStream = ref.read(ionConnectNotifierProvider.notifier).requestEntities(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
  final eventsList = await eventsStream.cast<BookmarksSetEntity>().toList();
  final bookmarksSets = eventsList.cast<BookmarksSetEntity>();
  return Map.fromEntries(
    bookmarkTypesList.map((type) {
      final bookmarksSet = bookmarksSets.firstWhereOrNull((set) => set.data.type == type);
      return MapEntry(type, bookmarksSet);
    }),
  );
}

@riverpod
Future<BookmarksSetData?> currentUserChatBookmarksData(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }
  final bookmarksSet = await ref.watch(
    bookmarksProvider(currentPubkey, const BookmarkTypes([BookmarksSetType.chats])).future,
  );

  return bookmarksSet[BookmarksSetType.chats]?.data;
}

@riverpod
Future<Map<BookmarksSetType, BookmarksSetEntity?>> currentUserFeedBookmarks(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return {};
  }
  return ref.watch(
    bookmarksProvider(
      currentPubkey,
      const BookmarkTypes(
        [BookmarksSetType.posts, BookmarksSetType.videos, BookmarksSetType.articles],
      ),
    ).future,
  );
}

@riverpod
Future<List<ReplaceableEventReference>> currentUserFeedBookmarksRefs(Ref ref) async {
  final bookmarksMap = await ref.watch(currentUserFeedBookmarksProvider.future);
  return bookmarksMap.values
      .whereType<BookmarksSetEntity>()
      .expand((set) => [...set.data.postsRefs, ...set.data.articlesRefs])
      .toList();
}

@riverpod
Future<List<IonConnectEntity>> currentUserFeedBookmarksEntities(Ref ref) async {
  final bookmarksRefs = await ref.watch(currentUserFeedBookmarksRefsProvider.future);

  final entityFutures = bookmarksRefs.map((eventRef) {
    return ref.read(ionConnectEntityProvider(eventReference: eventRef).future);
  });

  final fetchedEntities = await Future.wait(entityFutures);
  return fetchedEntities.whereType<IonConnectEntity>().toList();
}

@riverpod
Future<int> currentUserBookmarksTotalAmount(Ref ref) async {
  final bookmarksMap = await ref.watch(currentUserFeedBookmarksProvider.future);
  final amountMap = bookmarksMap.map((type, bookmarksSet) {
    return MapEntry(
      type,
      bookmarksSet != null
          ? bookmarksSet.data.articlesRefs.length + bookmarksSet.data.postsRefs.length
          : 0,
    );
  });
  return amountMap.values.fold<int>(0, (sum, count) => sum + count);
}

@riverpod
Future<bool> isBookmarked(Ref ref, EventReference eventReference) async {
  final ionConnectEntity = await ref.read(
    ionConnectEntityProvider(eventReference: eventReference).future,
  );
  if (ionConnectEntity == null) return false;

  final currentBookmarks = await ref.watch(currentUserFeedBookmarksProvider.future);
  return switch (ionConnectEntity) {
    ModifiablePostEntity() => currentBookmarks.values.any(
        (bookmarksSet) =>
            bookmarksSet?.data.postsRefs.contains(ionConnectEntity.toEventReference()) ?? false,
      ),
    ArticleEntity() => currentBookmarks[BookmarksSetType.articles]
            ?.data
            .articlesRefs
            .contains(ionConnectEntity.toEventReference()) ??
        false,
    _ => false,
  };
}

@riverpod
class BookmarksNotifier extends _$BookmarksNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleBookmark(EventReference eventReference) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final ionConnectEntity = await ref.read(
        ionConnectEntityProvider(eventReference: eventReference).future,
      );
      if (ionConnectEntity == null) {
        throw EntityNotFoundException(eventReference);
      }

      final bookmarkType = _getBookmarkType(ionConnectEntity);

      final bookmarksMap = await ref.read(currentUserFeedBookmarksProvider.future);
      final bookmarksSet = bookmarksMap[bookmarkType];
      final bookmarksSetsData = bookmarksMap.map((key, value) => MapEntry(key, value?.data));

      final postsRefs = Set<ReplaceableEventReference>.from(bookmarksSet?.data.postsRefs ?? []);
      final articlesRefs =
          Set<ReplaceableEventReference>.from(bookmarksSet?.data.articlesRefs ?? []);

      switch (ionConnectEntity) {
        case ModifiablePostEntity():
          _toggleBookmark(postsRefs, ionConnectEntity);
        case ArticleEntity():
          _toggleBookmark(articlesRefs, ionConnectEntity);
        default:
          return;
      }

      final newSingleBookmarksSetData = BookmarksSetData(
        type: bookmarkType,
        postsRefs: postsRefs.toList(),
        articlesRefs: articlesRefs.toList(),
      );

      final bookmarksData = BookmarksData(
        ids: [],
        bookmarksSetRefs: bookmarksSetsData.values
            .map((data) => data?.toReplaceableEventReference(currentPubkey))
            .nonNulls
            .toList(),
      );

      await ref
          .read(ionConnectNotifierProvider.notifier)
          .sendEntitiesData([newSingleBookmarksSetData, bookmarksData]);
    });
  }

  BookmarksSetType _getBookmarkType(IonConnectEntity entity) {
    return switch (entity) {
      ArticleEntity() => BookmarksSetType.articles,
      ModifiablePostEntity(data: ModifiablePostData(hasVideo: true)) => BookmarksSetType.videos,
      ModifiablePostEntity() => BookmarksSetType.posts,
      _ => throw UnsupportedEntityBookmarking(entity),
    };
  }

  void _toggleBookmark(Set<ReplaceableEventReference> refs, ReplaceableEntity post) {
    final ref = post.toEventReference();
    if (refs.contains(ref)) {
      refs.remove(ref);
    } else {
      refs.add(ref);
    }
  }
}
