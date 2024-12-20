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
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
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

  return ref.watch(
    currentUserBookmarksProvider.select(
      (state) => switch (nostrEntity) {
        PostEntity() => state.valueOrNull?.values.any(
              (bookmarksSet) => bookmarksSet?.data.postsIds.contains(nostrEntity.id) ?? false,
            ) ??
            false,
        ArticleEntity() => state.valueOrNull?[BookmarksSetType.articles]?.data.articlesRefs
                .contains(nostrEntity.toReplaceableEventReference()) ??
            false,
        _ => false,
      },
    ),
  );
}

@riverpod
bool isArticleBookmarked(Ref ref, ArticleEntity article) {
  final articleRef = article.toReplaceableEventReference();
  return ref.watch(
    currentUserBookmarksProvider.select(
      (state) =>
          state.valueOrNull?[BookmarksSetType.articles]?.data.articlesRefs.contains(articleRef) ??
          false,
    ),
  );
}

@riverpod
class BookmarksNotifier extends _$BookmarksNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleBookmark(
    EventReference eventReference, {
    required BookmarksSetType type,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentPubkey = ref.read(currentPubkeySelectorProvider);

      if (currentPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final nostrEntity = await ref.read(
        nostrEntityProvider(eventReference: eventReference).future,
      );
      if (nostrEntity == null) return;

      final bookmarksMap = await ref.read(currentUserBookmarksProvider.future);
      final bookmarksSet = bookmarksMap[type];

      if (nostrEntity is PostEntity) {
        final postId = nostrEntity.id;
        final bookmarksIds = Set<String>.from(bookmarksSet?.data.postsIds ?? []);
        if (bookmarksIds.contains(postId)) {
          bookmarksIds.remove(postId);
        } else {
          bookmarksIds.add(postId);
        }

        final newSingleBookmarksSetData = BookmarksSetData(
          type: type,
          postsIds: bookmarksIds.toList(),
          articlesRefs: bookmarksSet?.data.articlesRefs ?? [],
        );

        bookmarksMap[type] = bookmarksSet?.copyWith(data: newSingleBookmarksSetData);
      } else if (nostrEntity is ArticleEntity) {
        final articleRef = nostrEntity.toReplaceableEventReference();
        final bookmarksRefs =
            Set<ReplaceableEventReference>.from(bookmarksSet?.data.articlesRefs ?? []);
        if (bookmarksRefs.contains(articleRef)) {
          bookmarksRefs.remove(articleRef);
        } else {
          bookmarksRefs.add(articleRef);
        }

        final newSingleBookmarksSetData = BookmarksSetData(
          type: type,
          postsIds: bookmarksSet?.data.postsIds ?? [],
          articlesRefs: bookmarksRefs.toList(),
        );

        bookmarksMap[type] = bookmarksSet?.copyWith(data: newSingleBookmarksSetData);
      }

      final bookmarksData = BookmarksData(
        ids: [],
        bookmarksSetRefs: bookmarksMap.values
            .map((bookmarksSet) => bookmarksSet?.data.toReplaceableEventReference(currentPubkey))
            .whereNotNull()
            .toList(),
      );

      await ref
          .read(nostrNotifierProvider.notifier)
          .sendEntitiesData([bookmarksMap[type]!.data, bookmarksData]);
    });
  }
}
