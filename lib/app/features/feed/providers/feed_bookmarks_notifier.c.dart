// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_collection.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_bookmarks_notifier.c.g.dart';

@riverpod
Stream<BookmarksCollectionEntity?> bookmarksCollectionStream(
  Ref ref,
  String pubkey,
  String collectionDTag,
) {
  final request = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [BookmarksCollectionEntity.kind],
        tags: {
          '#d': [collectionDTag],
          '#b': [pubkey],
        },
      ),
    );

  final events = ref.watch(
    ionConnectEventsSubscriptionProvider(
      request,
      actionSource: ActionSourceUser(pubkey),
    ),
  );

  return events.map(
    BookmarksCollectionEntity.fromEventMessage,
  );
}

@riverpod
Future<List<ReplaceableEventReference>> currentUserBookmarksCollectionRefs(
  Ref ref,
  String collectionDTag,
) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return [];
  }

  final bookmarksCollection = await ref.watch(
    bookmarksCollectionStreamProvider(
      currentPubkey,
      collectionDTag,
    ).future,
  );

  return bookmarksCollection?.data.refs ?? [];
}

@Riverpod(keepAlive: true)
Future<List<ReplaceableEventReference>> currentUserBookmarksCollectionsRefs(
  Ref ref,
) async {
  final collectionsRefs = await ref.watch(
    currentUserBookmarksCollectionRefsProvider(
      BookmarksCollectionEntity.collectionsDTag,
    ).future,
  );
  return collectionsRefs.where((ref) => ref.kind == BookmarksCollectionEntity.kind).toList();
}

@Riverpod(keepAlive: true)
Future<List<ReplaceableEventReference>> currentUserAllBookmarksCollectionRefs(
  Ref ref,
) async {
  final bookmarksCollectionRefs = await ref.watch(
    currentUserBookmarksCollectionRefsProvider(
      BookmarksCollectionEntity.defaultCollectionDTag,
    ).future,
  );
  return bookmarksCollectionRefs;
}

@riverpod
bool isFeedBookmarked(Ref ref, EventReference eventReference) {
  if (eventReference is! ReplaceableEventReference) {
    return false;
  }

  final allBookmarksRefs =
      ref.watch(currentUserAllBookmarksCollectionRefsProvider).valueOrNull ?? [];

  return allBookmarksRefs.contains(eventReference);
}

@riverpod
class FeedBookmarksNotifier extends _$FeedBookmarksNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleBookmark(EventReference eventReference) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final allBookmarksRefs = await ref.read(
        currentUserAllBookmarksCollectionRefsProvider.future,
      );

      final newAllBookmarksRefs = Set<ReplaceableEventReference>.from(allBookmarksRefs);
      if (eventReference is ReplaceableEventReference) {
        if (newAllBookmarksRefs.contains(eventReference)) {
          newAllBookmarksRefs.remove(eventReference);
        } else {
          newAllBookmarksRefs.add(eventReference);
        }
      }

      final newBookmarksCollectionData = BookmarksCollectionData(
        type: BookmarksCollectionEntity.defaultCollectionDTag,
        refs: newAllBookmarksRefs.toList(),
      );

      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
        [newBookmarksCollectionData],
        actionSource: ActionSourceUser(currentPubkey),
      );
    });
  }
}
