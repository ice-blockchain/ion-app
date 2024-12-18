// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_notifier.c.g.dart';

@Riverpod(keepAlive: true)
Future<Map<BookmarksSetType, BookmarksSetEntity?>> bookmarks(
  Ref ref,
  String pubkey, {
}) async {
  final bookmarksTypes = BookmarksSetType.values;
  final bookmarksMap = Map.fromEntries(
    bookmarksTypes.map((type) {
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
        d: bookmarksTypes.map((type) => type.name).toList(),
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

@Riverpod(keepAlive: true)
Future<Map<BookmarksSetType, BookmarksSetEntity?>> currentUserBookmarks(
  Ref ref, {
  List<BookmarksSetType>? types,
}) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return {};
  }
  return ref.watch(bookmarksProvider(currentPubkey, types: types).future);
}

@riverpod
bool isBookmarked(Ref ref, String id, {BookmarksSetType? type}) {
  final types = type != null ? [type] : null;
  return ref.watch(
    currentUserBookmarksProvider(types: types).select((state) {
      final result = state.valueOrNull?.values
              .any((bookmarksSet) => bookmarksSet?.data.ids.contains(id) ?? false) ??
          false;
      print('IS BOOKMARKED provider: $result, id: $id');
      return result;
    }),
  );
}

@riverpod
class BookmarksNotifier extends _$BookmarksNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleBookmark(String pubkey, {required BookmarksSetType type}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentPubkey = ref.read(currentPubkeySelectorProvider);

      if (currentPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final bookmarksMap = await ref.read(currentUserBookmarksProvider().future);
      final bookmarksSet = bookmarksMap[type];

      final bookmarksIds = Set<String>.from(bookmarksSet?.data.ids ?? []);
      if (bookmarksIds.contains(pubkey)) {
        bookmarksIds.remove(pubkey);
      } else {
        bookmarksIds.add(pubkey);
      }

      final newSingleBookmarksSetData = BookmarksSetData(type: type, ids: bookmarksIds.toList());

      bookmarksMap[type] = bookmarksSet?.copyWith(data: newSingleBookmarksSetData);

      final bookmarksData = BookmarksData(
        ids: [],
        bookmarksSetRefs: bookmarksMap.values
            .map((bookmarksSet) => bookmarksSet?.data.toReplaceableEventReference(currentPubkey))
            .whereNotNull()
            .toList(),
      );

      await ref
          .read(nostrNotifierProvider.notifier)
          .sendEntitiesData([newSingleBookmarksSetData, bookmarksData]);
    });
  }
}
