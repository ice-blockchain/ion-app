// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/auth/providers/delegation_complete_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_collection.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/action_source.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_subscription_provider.c.dart';
import 'package:ion/app/features/ion_connect/repository/event_messages_repository.c.dart';
import 'package:ion/app/services/uuid/uuid.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_bookmarks_notifier.c.g.dart';

@riverpod
Stream<BookmarksCollectionEntity?> bookmarksCollectionStream(
  Ref ref,
  String pubkey,
  String collectionDTag,
) {
  final streamController = StreamController<BookmarksCollectionEntity?>.broadcast();
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

  var receivedAnyEvents = false;
  void onEndOfStoredEvents() {
    if (!receivedAnyEvents) {
      streamController.add(null);
    }
  }

  final events = ref.watch(
    ionConnectEventsSubscriptionProvider(
      request,
      onEndOfStoredEvents: onEndOfStoredEvents,
    ),
  );

  final subscription = events.listen((event) {
    receivedAnyEvents = true;
    streamController.add(BookmarksCollectionEntity.fromEventMessage(event));
  });
  streamController.onCancel = subscription.cancel;

  return streamController.stream;
}

@Riverpod(keepAlive: true)
class FeedBookmarksNotifier extends _$FeedBookmarksNotifier {
  @override
  Future<BookmarksCollectionEntity?> build({
    String collectionDTag = BookmarksCollectionEntity.defaultCollectionDTag,
  }) async {
    final authState = await ref.watch(authProvider.future);

    if (!authState.isAuthenticated) {
      return null;
    }

    final currentPubkey = ref.watch(currentPubkeySelectorProvider);
    final delegationComplete = ref.watch(delegationCompleteProvider).valueOrNull.falseOrValue;
    if (currentPubkey == null || !delegationComplete) {
      return null;
    }

    final bookmarksCollection = await ref.watch(
      bookmarksCollectionStreamProvider(
        currentPubkey,
        collectionDTag,
      ).future,
    );

    return bookmarksCollection;
  }

  Future<void> toggleBookmark(EventReference eventReference) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentPubkey = ref.watch(currentPubkeySelectorProvider);
      final bookmarksCollection = state.valueOrNull;
      if (currentPubkey == null || bookmarksCollection == null) {
        return state.value;
      }
      final newAllBookmarksRefs = <EventReference>[];
      if (bookmarksCollection.data.refs.contains(eventReference)) {
        newAllBookmarksRefs
          ..addAll(bookmarksCollection.data.refs)
          ..remove(eventReference);

        // If toggling off in the default collection, also remove from all other collections
        if (bookmarksCollection.data.type == BookmarksCollectionEntity.defaultCollectionDTag) {
          final collectionsRefs = await ref.read(
            feedBookmarkCollectionsNotifierProvider.future,
          );
          final collectionsDTags = collectionsRefs
              .map((collectionRef) => collectionRef.dTag)
              .whereType<String>()
              .where((dTag) => dTag != BookmarksCollectionEntity.defaultCollectionDTag)
              .toList();
          await Future.wait(
            collectionsDTags.map(
              (dTag) async {
                final isIncluded = (await ref.read(
                      feedBookmarksNotifierProvider(
                        collectionDTag: dTag,
                      ).future,
                    ))
                        ?.data
                        .refs
                        .contains(eventReference) ??
                    false;
                if (isIncluded) {
                  await ref
                      .read(
                        feedBookmarksNotifierProvider(
                          collectionDTag: dTag,
                        ).notifier,
                      )
                      .toggleBookmark(eventReference);
                }
              },
            ),
          );
        }
      } else {
        newAllBookmarksRefs
          ..add(eventReference)
          ..addAll(bookmarksCollection.data.refs);
        if (bookmarksCollection.data.type == BookmarksCollectionEntity.defaultCollectionDTag) {
          unawaited(ref.read(ionConnectDbCacheProvider.notifier).saveRef(eventReference));
        }
        if (bookmarksCollection.data.type != BookmarksCollectionEntity.defaultCollectionDTag) {
          final isIncluded = (await ref.read(
                feedBookmarksNotifierProvider().future,
              ))
                  ?.data
                  .refs
                  .contains(eventReference) ??
              false;
          if (!isIncluded) {
            await ref
                .read(
                  feedBookmarksNotifierProvider().notifier,
                )
                .toggleBookmark(eventReference);
          }
        }
      }

      final newBookmarksCollectionData = BookmarksCollectionData(
        type: bookmarksCollection.data.type,
        refs: newAllBookmarksRefs.toList(),
        title: bookmarksCollection.data.title,
      );

      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
        [newBookmarksCollectionData],
        actionSource: ActionSourceUser(currentPubkey),
      );
      return state.value;
    });
  }
}

@riverpod
bool isBookmarkedInCollection(
  Ref ref,
  EventReference eventReference, {
  String collectionDTag = BookmarksCollectionEntity.defaultCollectionDTag,
}) {
  final feedBookmarksNotifierState =
      ref.watch(feedBookmarksNotifierProvider(collectionDTag: collectionDTag));
  return feedBookmarksNotifierState.valueOrNull?.data.refs.contains(eventReference) ?? false;
}

@riverpod
Future<List<EventReference>> filteredBookmarksRefs(
  Ref ref, {
  required String collectionDTag,
  required String query,
}) async {
  final collectionEntity =
      await ref.watch(feedBookmarksNotifierProvider(collectionDTag: collectionDTag).future);

  final allRefs = collectionEntity?.data.refs ?? [];

  if (query.isEmpty) return allRefs;

  final rawEvents = await ref.read(eventMessagesRepositoryProvider).getFilteredRaw(allRefs, query);
  return rawEvents.map((event) => event.eventReference).toList();
}

@Riverpod(keepAlive: true)
void feedBookmarksSync(Ref ref) {
  ref.listen<AsyncValue<BookmarksCollectionEntity?>>(
    feedBookmarksNotifierProvider(),
    (previous, next) {
      final collection = next.value;
      if (collection != null) {
        ref.read(ionConnectDbCacheProvider.notifier).saveAllNonExistingRefs(collection.data.refs);
      }
    },
  );
}

@Riverpod(keepAlive: true)
class FeedBookmarkCollectionsNotifier extends _$FeedBookmarkCollectionsNotifier {
  @override
  Future<List<ReplaceableEventReference>> build() async {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentPubkey == null) {
      return [];
    }

    final bookmarksCollection = await ref.watch(
      bookmarksCollectionStreamProvider(
        currentPubkey,
        BookmarksCollectionEntity.collectionsDTag,
      ).future,
    );
    final collectionsRefs = bookmarksCollection?.data.refs ?? [];

    final bookmarkCollections = collectionsRefs
        .where(
          (collectionsRef) =>
              collectionsRef is ReplaceableEventReference &&
              collectionsRef.kind == BookmarksCollectionEntity.kind,
        )
        .cast<ReplaceableEventReference>()
        .toList();
    if (bookmarkCollections
        .none((ref) => ref.dTag == BookmarksCollectionEntity.defaultCollectionDTag)) {
      final bookmarksData = BookmarksData(
        ids: [],
        bookmarksSetRefs: [
          ReplaceableEventReference(
            pubkey: currentPubkey,
            kind: BookmarksCollectionEntity.kind,
            dTag: BookmarksCollectionEntity.collectionsDTag,
          ),
        ],
      );
      final collectionsData = BookmarksCollectionData(
        type: BookmarksCollectionEntity.collectionsDTag,
        refs: [
          ReplaceableEventReference(
            pubkey: currentPubkey,
            kind: BookmarksCollectionEntity.kind,
            dTag: BookmarksCollectionEntity.defaultCollectionDTag,
          ),
        ],
      );
      const defaultBookmarksCollectionData = BookmarksCollectionData(
        type: BookmarksCollectionEntity.defaultCollectionDTag,
        refs: [],
      );

      await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
        [defaultBookmarksCollectionData, collectionsData, bookmarksData],
        actionSource: ActionSourceUser(currentPubkey),
      );
    }

    return bookmarkCollections;
  }

  Future<void> createCollection(String title) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    final currentBookmarkCollectionsRefs = state.valueOrNull ?? [];
    if (currentPubkey == null || currentBookmarkCollectionsRefs.isEmpty) {
      return;
    }

    final newCollectionData = BookmarksCollectionData(
      type: 'homefeed_collection_${generateUuid()}',
      refs: [],
      title: title,
    );

    final updatedCollectionsRefs = <ReplaceableEventReference>[
      ...currentBookmarkCollectionsRefs,
      ReplaceableEventReference(
        pubkey: currentPubkey,
        kind: BookmarksCollectionEntity.kind,
        dTag: newCollectionData.type,
      ),
    ];
    final updatedAllCollectionsData = BookmarksCollectionData(
      type: BookmarksCollectionEntity.collectionsDTag,
      refs: updatedCollectionsRefs,
    );

    await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
      [newCollectionData, updatedAllCollectionsData],
      actionSource: ActionSourceUser(currentPubkey),
    );
  }

  Future<void> deleteCollection(String collectionDTag) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    final currentBookmarkCollectionsRefs = state.valueOrNull ?? [];
    if (currentPubkey == null ||
        currentBookmarkCollectionsRefs.isEmpty ||
        collectionDTag == BookmarksCollectionEntity.defaultCollectionDTag) {
      return;
    }

    final updatedRootRefs =
        currentBookmarkCollectionsRefs.where((ref) => ref.dTag != collectionDTag).toList();

    final updatedAllCollectionsData = BookmarksCollectionData(
      type: BookmarksCollectionEntity.collectionsDTag,
      refs: updatedRootRefs,
    );

    final deleteCollectionData = BookmarksCollectionData(
      type: collectionDTag,
      refs: [],
    );

    await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
      [deleteCollectionData, updatedAllCollectionsData],
      actionSource: ActionSourceUser(currentPubkey),
    );
  }

  Future<void> renameCollection(
    BookmarksCollectionData bookmarksCollectionData,
    String newTitle,
  ) async {
    final currentPubkey = ref.read(currentPubkeySelectorProvider);
    final currentBookmarkCollectionsRefs = state.valueOrNull ?? [];
    final collectionDTag = bookmarksCollectionData.type;
    if (currentPubkey == null ||
        collectionDTag == BookmarksCollectionEntity.defaultCollectionDTag ||
        !currentBookmarkCollectionsRefs.any((ref) => ref.dTag == collectionDTag)) {
      return;
    }

    final updatedCollectionData = BookmarksCollectionData(
      type: collectionDTag,
      refs: bookmarksCollectionData.refs,
      title: newTitle,
    );

    await ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData(
      [updatedCollectionData],
      actionSource: ActionSourceUser(currentPubkey),
    );
  }
}
