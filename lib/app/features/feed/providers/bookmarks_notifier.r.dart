// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/auth/providers/auth_provider.m.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.f.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.f.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.r.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.r.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_notifier.r.g.dart';

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
          masterPubkey: pubkey,
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
      final bookmarksSet = bookmarksSets.firstWhereOrNull((set) => set.data.type == type.dTagName);
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
