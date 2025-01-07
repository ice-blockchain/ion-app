// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/model/event_reference.c.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';
import 'package:ion/app/features/nostr/model/replaceable_event_reference.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_entity_provider.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_notifier.c.g.dart';

@riverpod
Future<Map<BookmarksSetType, BookmarksSetEntity?>> bookmarks(
  Ref ref,
  String pubkey,
) async {
  final bookmarksMap = Map.fromEntries(
    BookmarksSetType.values.map((type) {
      final cacheKey = BookmarksSetEntity.cacheKeyBuilder(pubkey: pubkey, type: type);
      final bookmarkSet = ref.watch(
        nostrCacheProvider.select(cacheSelector<BookmarksSetEntity>(cacheKey)),
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
        d: BookmarksSetType.values.map((type) => type.name).toList(),
        authors: [pubkey],
      ),
    );

  final eventsStream = ref.read(nostrNotifierProvider.notifier).requestEntities(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
  final eventsList = await eventsStream.cast<BookmarksSetEntity>().toList();
  final bookmarksSets = eventsList.cast<BookmarksSetEntity>();
  return Map.fromEntries(
    BookmarksSetType.values.map((type) {
      final bookmarksSet = bookmarksSets.firstWhereOrNull((set) => set.data.type == type);
      return MapEntry(type, bookmarksSet);
    }),
  );
}

@riverpod
Future<Map<BookmarksSetType, BookmarksSetEntity?>> currentUserBookmarks(Ref ref) async {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);
  if (currentPubkey == null) {
    return {};
  }
  return ref.watch(bookmarksProvider(currentPubkey).future);
}

@riverpod
Future<bool> isBookmarked(Ref ref, EventReference eventReference) async {
  final nostrEntity = await ref.read(
    nostrEntityProvider(eventReference: eventReference).future,
  );
  if (nostrEntity == null) return false;

  final currentBookmarks = await ref.watch(currentUserBookmarksProvider.future);
  return switch (nostrEntity) {
    PostEntity() => currentBookmarks.values.any(
        (bookmarksSet) => bookmarksSet?.data.postsIds.contains(nostrEntity.id) ?? false,
      ),
    ArticleEntity() => currentBookmarks[BookmarksSetType.articles]
            ?.data
            .articlesRefs
            .contains(nostrEntity.toReplaceableEventReference()) ??
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
      final currentPubkey = await ref.read(currentPubkeySelectorProvider.future);
      if (currentPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final nostrEntity = await ref.read(
        nostrEntityProvider(eventReference: eventReference).future,
      );
      if (nostrEntity == null) return;

      final bookmarkType = _getBookmarkType(nostrEntity);
      if (bookmarkType == null) return;

      final bookmarksMap = await ref.read(currentUserBookmarksProvider.future);
      final bookmarksSet = bookmarksMap[bookmarkType];
      final bookmarksSetsData = bookmarksMap.map((key, value) => MapEntry(key, value?.data));

      final postsIds = Set<String>.from(bookmarksSet?.data.postsIds ?? []);
      final articlesRefs =
          Set<ReplaceableEventReference>.from(bookmarksSet?.data.articlesRefs ?? []);

      switch (nostrEntity) {
        case PostEntity():
          _togglePostBookmark(postsIds, nostrEntity);
        case ArticleEntity():
          _toggleArticleBookmark(articlesRefs, nostrEntity);
        default:
          return;
      }

      final newSingleBookmarksSetData = BookmarksSetData(
        type: bookmarkType,
        postsIds: postsIds.toList(),
        articlesRefs: articlesRefs.toList(),
      );

      final bookmarksData = BookmarksData(
        ids: [],
        bookmarksSetRefs: bookmarksSetsData.values
            .map((data) => data?.toReplaceableEventReference(currentPubkey))
            .whereNotNull()
            .toList(),
      );

      await ref
          .read(nostrNotifierProvider.notifier)
          .sendEntitiesData([newSingleBookmarksSetData, bookmarksData]);
    });
  }

  BookmarksSetType? _getBookmarkType(NostrEntity entity) {
    return switch (entity) {
      ArticleEntity() => BookmarksSetType.articles,
      PostEntity(data: PostData(isStory: true)) => BookmarksSetType.stories,
      PostEntity(data: PostData(hasVideo: true)) => BookmarksSetType.videos,
      PostEntity() => BookmarksSetType.posts,
      _ => null,
    };
  }

  void _togglePostBookmark(Set<String> postsIds, PostEntity post) {
    final postId = post.id;
    if (postsIds.contains(postId)) {
      postsIds.remove(postId);
    } else {
      postsIds.add(postId);
    }
  }

  void _toggleArticleBookmark(Set<ReplaceableEventReference> articlesRefs, ArticleEntity article) {
    final articleRef = article.toReplaceableEventReference();
    if (articlesRefs.contains(articleRef)) {
      articlesRefs.remove(articleRef);
    } else {
      articlesRefs.add(articleRef);
    }
  }
}
