// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks.c.dart';
import 'package:ion/app/features/feed/data/models/bookmarks/bookmarks_set.c.dart';
import 'package:ion/app/features/feed/providers/bookmarks_notifier.c.dart';
import 'package:ion/app/features/feed/providers/feed_bookmarks_notifier.c.dart';
import 'package:ion/app/features/ion_connect/ion_connect.dart';
import 'package:ion/app/features/ion_connect/model/global_subscription_event_handler.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_db_cache_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmarks_handler.c.g.dart';

class BookmarksHandler extends GlobalSubscriptionEventHandler {
  BookmarksHandler(this.bookmarksNotifier);

  final BookmarksNotifier bookmarksNotifier;

  @override
  bool canHandle(EventMessage eventMessage) {
    return eventMessage.kind == BookmarksEntity.kind;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = BookmarksEntity.fromEventMessage(eventMessage);
    await bookmarksNotifier.setState(entity);
  }
}

@riverpod
BookmarksHandler bookmarksHandler(Ref ref) {
  final bookmarksNotifier = ref.watch(bookmarksNotifierProvider.notifier);
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);

  if (currentPubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  return BookmarksHandler(bookmarksNotifier);
}

class BoookmarkSetHandler extends GlobalSubscriptionEventHandler {
  BoookmarkSetHandler(this.ref);

  final Ref ref;

  @override
  bool canHandle(EventMessage eventMessage) {
    return eventMessage.kind == BookmarksSetEntity.kind;
  }

  @override
  Future<void> handle(EventMessage eventMessage) async {
    final entity = BookmarksSetEntity.fromEventMessage(eventMessage);
    if (entity.data.type == BookmarksSetType.homeFeedCollectionsAll.dTagName) {
      unawaited(
        ref
            .read(ionConnectDbCacheProvider.notifier)
            .saveAllNonExistingRefs(entity.data.eventReferences),
      );
    }

    await ref
        .read(
          feedBookmarksNotifierProvider(
            collectionDTag: entity.data.type,
          ).notifier,
        )
        .setState(entity);
  }
}

@riverpod
BoookmarkSetHandler bookmarksSetHandler(Ref ref) {
  return BoookmarkSetHandler(ref);
}
