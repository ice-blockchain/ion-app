// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/muted_users_notifier.c.dart';
import 'package:ion/app/features/user_block/model/database/blocked_users_database.c.dart';
import 'package:ion/app/features/user_block/model/entities/blocked_user_entity.c.dart';
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
    final currentBlockList = ref.watch(currentUserBlockListNotifierProvider).valueOrNull;
    return currentBlockList?.any(
          (blockedUser) => blockedUser.data.blockedMasterPubkeys.contains(masterPubkey),
        ) ??
        false;
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
    final initiallyBlocked = initialEntities.any(
      (entity) =>
          entity.data.blockedMasterPubkeys.contains(currentUserMasterPubkey) &&
          entity.masterPubkey == masterPubkey,
    );

    final subscription =
        blockEventDao.watchBlockedByUsersEvents(currentUserMasterPubkey).listen((events) {
      final entities = events.map(BlockedUserEntity.fromEventMessage);
      final isBlocked = entities.any(
        (entity) =>
            entity.data.blockedMasterPubkeys.contains(currentUserMasterPubkey) &&
            entity.masterPubkey == masterPubkey,
      );
      state = AsyncValue.data(isBlocked);
    });

    ref.onDispose(subscription.cancel);

    return initiallyBlocked;
  }
}

@riverpod
class IsBlockedOrMutedOrBlockingNotifier extends _$IsBlockedOrMutedOrBlockingNotifier {
  @override
  Future<bool> build(String pubkey) async {
    final isBlocked = await ref.watch(isBlockedNotifierProvider(pubkey).future);
    final isBlockedBy = await ref.watch(isBlockedByNotifierProvider(pubkey).future);
    final isMuted = ref.watch(isUserMutedProvider(pubkey));
    return isBlocked || isBlockedBy || isMuted;
  }
}

@riverpod
class IsEntityBlockedOrMutedOrBlockingNotifier extends _$IsEntityBlockedOrMutedOrBlockingNotifier {
  @override
  Future<bool> build(IonConnectEntity entity) async {
    final isMainAuthorBlockedOrBlocking =
        await ref.watch(isBlockedOrMutedOrBlockingNotifierProvider(entity.masterPubkey).future);
    if (isMainAuthorBlockedOrBlocking) return true;
    return switch (entity) {
      ModifiablePostEntity() =>
        await ref.watch(isPostChildBlockedOrMutedOrBlockingNotifierProvider(entity).future),
      GenericRepostEntity() => await ref
          .watch(isGenericRepostChildBlockedOrMutedOrBlockingNotifierProvider(entity).future),
      _ => false,
    };
  }
}

@riverpod
class IsPostChildBlockedOrMutedOrBlockingNotifier
    extends _$IsPostChildBlockedOrMutedOrBlockingNotifier {
  @override
  Future<bool> build(ModifiablePostEntity entity) {
    final quotedEvent = entity.data.quotedEvent;
    if (quotedEvent == null) return Future.value(false);
    final quotedPost = ref.watch(
      ionConnectSyncEntityProvider(eventReference: quotedEvent.eventReference),
    );
    if (quotedPost == null) return Future.value(false);
    return ref.watch(isEntityBlockedOrMutedOrBlockingNotifierProvider(quotedPost).future);
  }
}

@riverpod
class IsGenericRepostChildBlockedOrMutedOrBlockingNotifier
    extends _$IsGenericRepostChildBlockedOrMutedOrBlockingNotifier {
  @override
  Future<bool> build(GenericRepostEntity repost) {
    final entity =
        ref.watch(ionConnectSyncEntityProvider(eventReference: repost.data.eventReference));
    if (entity == null) return Future.value(false);
    return ref.watch(isEntityBlockedOrMutedOrBlockingNotifierProvider(entity).future);
  }
}

@riverpod
class BlockListNotifier extends _$BlockListNotifier {
  @override
  Future<void> build() async {}

  Future<void> toggleBlocked(String masterPubkey) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() async {
      final currentMasterPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentMasterPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final blockedUsers = ref.read(currentUserBlockListNotifierProvider).value ?? [];
      final blockedUserEntity = blockedUsers.firstWhereOrNull(
        (blockedUser) => blockedUser.data.blockedMasterPubkeys.contains(masterPubkey),
      );

      if (blockedUserEntity != null) {
        await _unblockUser(blockedUserEntity.data.sharedId, masterPubkey);
      } else {
        await _blockUser(masterPubkey);
      }
    });
  }

  Future<void> _blockUser(String masterPubkey) async {
    final currentMasterPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    await Future.wait([
      ref.read(sendBlockEventServiceProvider.future).then(
            (service) => service.sendBlockEvent(masterPubkey),
          ),
      ref.read(followListManagerProvider.notifier).unfollow(masterPubkey),
    ]);
  }

  Future<void> _unblockUser(String sharedId, String masterPubkey) async {
    final currentMasterPubkey = ref.read(currentPubkeySelectorProvider);
    if (currentMasterPubkey == null) {
      throw UserMasterPubkeyNotFoundException();
    }

    final sendBlockEventService = await ref.read(sendBlockEventServiceProvider.future);
    await sendBlockEventService.sendDeleteBlockEvent(sharedId, masterPubkey);
  }
}
