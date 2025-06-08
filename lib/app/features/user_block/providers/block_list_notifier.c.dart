// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user_block/data/models/database/blocked_users_database.c.dart';
import 'package:ion/app/features/user_block/data/models/entities/blocked_user_entity.c.dart';
import 'package:ion/app/features/user_block/providers/send_block_event_service.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_list_notifier.c.g.dart';

@riverpod
class CurrentUserBlockListNotifier extends _$CurrentUserBlockListNotifier {
  @override
  Future<List<BlockedUserEntity>> build() async {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final blockEventDao = ref.watch(blockEventDaoProvider);

    final initialEvents = await blockEventDao.getBlockedUsersEvents(currentUserMasterPubkey);
    final initialEntities = initialEvents.map(BlockedUserEntity.fromEventMessage).toList();
    state = AsyncValue.data(initialEntities);

    final subscription =
        blockEventDao.watchBlockedUsersEvents(currentUserMasterPubkey).listen((blockEvents) {
      final entities = blockEvents.map(BlockedUserEntity.fromEventMessage).toList();
      state = AsyncValue.data(entities);
    });

    ref.onDispose(subscription.cancel);

    return initialEntities;
  }
}

@riverpod
class IsBlockedNotifier extends _$IsBlockedNotifier {
  @override
  Future<bool> build(String masterPubkey) async {
    final blockedUser = ref.watch(blockedUserWatchProvider(masterPubkey)).valueOrNull;

    return blockedUser != null && blockedUser.isBlocked;
  }
}

@riverpod
class IsBlockedByNotifier extends _$IsBlockedByNotifier {
  @override
  Future<bool> build(String masterPubkey) async {
    final currentUserMasterPubkey = ref.watch(currentPubkeySelectorProvider);
    if (currentUserMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final blockEventDao = ref.watch(blockEventDaoProvider);

    final initialEvents = await blockEventDao.getBlockedByUsersEvents(currentUserMasterPubkey);
    final initialEntities = initialEvents.map(BlockedUserEntity.fromEventMessage);
    final initiallyBlocked = initialEntities.any((entity) => entity.masterPubkey == masterPubkey);

    final subscription =
        blockEventDao.watchBlockedByUsersEvents(currentUserMasterPubkey).listen((events) {
      final entities = events.map(BlockedUserEntity.fromEventMessage);
      final isBlocked = entities.any((entity) => entity.masterPubkey == masterPubkey);
      state = AsyncValue.data(isBlocked);
    });

    ref.onDispose(subscription.cancel);

    return initiallyBlocked;
  }
}

@riverpod
class IsBlockedOrBlockedByNotifier extends _$IsBlockedOrBlockedByNotifier {
  @override
  Future<bool> build(String pubkey) async {
    final isBlocked = await ref.watch(isBlockedNotifierProvider(pubkey).future);
    final isBlockedBy = await ref.watch(isBlockedByNotifierProvider(pubkey).future);

    return isBlocked || isBlockedBy;
  }
}

@riverpod
class IsEntityBlockedOrBlockedByNotifier extends _$IsEntityBlockedOrBlockedByNotifier {
  @override
  Future<bool> build(IonConnectEntity entity) async {
    final isMainAuthorBlockedOrBlocking =
        await ref.watch(isBlockedOrBlockedByNotifierProvider(entity.masterPubkey).future);
    if (isMainAuthorBlockedOrBlocking) return true;
    return switch (entity) {
      ModifiablePostEntity() =>
        await ref.watch(isPostChildBlockedOrBlockedByNotifierProvider(entity).future),
      GenericRepostEntity() =>
        await ref.watch(isGenericRepostChildBlockedOrBlockedByNotifierProvider(entity).future),
      _ => false,
    };
  }
}

@riverpod
class IsPostChildBlockedOrBlockedByNotifier extends _$IsPostChildBlockedOrBlockedByNotifier {
  @override
  Future<bool> build(ModifiablePostEntity entity) {
    final quotedEvent = entity.data.quotedEvent;
    if (quotedEvent == null) return Future.value(false);
    final quotedPost = ref.watch(
      ionConnectSyncEntityProvider(eventReference: quotedEvent.eventReference),
    );
    if (quotedPost == null) return Future.value(false);
    return ref.watch(isEntityBlockedOrBlockedByNotifierProvider(quotedPost).future);
  }
}

@riverpod
class IsGenericRepostChildBlockedOrBlockedByNotifier
    extends _$IsGenericRepostChildBlockedOrBlockedByNotifier {
  @override
  Future<bool> build(GenericRepostEntity repost) {
    final entity =
        ref.watch(ionConnectSyncEntityProvider(eventReference: repost.data.eventReference));
    if (entity == null) return Future.value(false);
    return ref.watch(isEntityBlockedOrBlockedByNotifierProvider(entity).future);
  }
}
