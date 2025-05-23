// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/muted_users_notifier.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_list_notifier.c.g.dart';

@riverpod
Future<BlockListEntity?> blockList(
  Ref ref,
  String pubkey, {
  bool cache = true,
}) async {
  return await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(pubkey: pubkey, kind: BlockListEntity.kind),
      cache: cache,
    ).future,
  ) as BlockListEntity?;
}

@riverpod
BlockListEntity? cachedBlockList(
  Ref ref,
  String pubkey,
) {
  return ref.watch(
    ionConnectSyncEntityProvider(
      eventReference: ReplaceableEventReference(pubkey: pubkey, kind: BlockListEntity.kind),
    ),
  ) as BlockListEntity?;
}

@riverpod
Future<BlockListEntity?> currentUserBlockList(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }
  return ref.watch(blockListProvider(currentPubkey).future);
}

@riverpod
BlockListEntity? cachedCurrentUserBlockList(Ref ref) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }
  return ref.watch(cachedBlockListProvider(currentPubkey));
}

@riverpod
bool isBlocked(Ref ref, String pubkey) {
  final currentBlockList = ref.watch(cachedCurrentUserBlockListProvider);
  return currentBlockList?.data.pubkeys.contains(pubkey) ?? false;
}

@riverpod
Future<bool> isBlocking(Ref ref, String pubkey) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return false;
  }
  final otherUserBlockList = await ref.watch(blockListProvider(pubkey).future);
  return otherUserBlockList?.data.pubkeys.contains(currentPubkey) ?? false;
}

@riverpod
bool cachedIsBlocking(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return false;
  }
  final otherUserBlockList = ref.watch(cachedBlockListProvider(pubkey));
  return otherUserBlockList?.data.pubkeys.contains(currentPubkey) ?? false;
}

@riverpod
bool isBlockedOrMutedOrBlocking(Ref ref, String pubkey) {
  final results = (
    ref.watch(isBlockedProvider(pubkey)),
    ref.watch(cachedIsBlockingProvider(pubkey)),
    ref.watch(isUserMutedProvider(pubkey)),
  );
  return results.$1 || results.$2 || results.$3;
}

@riverpod
bool isEntityBlockedOrMutedOrBlocking(
  Ref ref,
  IonConnectEntity entity,
) {
  final isMainAuthorBlockedOrBlocking =
      ref.watch(isBlockedOrMutedOrBlockingProvider(entity.masterPubkey));
  if (isMainAuthorBlockedOrBlocking) return true;
  return switch (entity) {
    ModifiablePostEntity() => ref.watch(isPostChildBlockedOrMutedOrBlockingProvider(entity)),
    GenericRepostEntity() =>
      ref.watch(isGenericRepostChildBlockedOrMutedOrBlockingProvider(entity)),
    _ => false,
  };
}

@riverpod
bool isPostChildBlockedOrMutedOrBlocking(
  Ref ref,
  ModifiablePostEntity entity,
) {
  final quotedEvent = entity.data.quotedEvent;
  if (quotedEvent == null) return false;
  final quotedPost = ref.watch(
    ionConnectSyncEntityProvider(eventReference: quotedEvent.eventReference),
  );
  if (quotedPost == null) return false;
  return ref.watch(isEntityBlockedOrMutedOrBlockingProvider(quotedPost));
}

@riverpod
bool isGenericRepostChildBlockedOrMutedOrBlocking(
  Ref ref,
  GenericRepostEntity repost,
) {
  final entity =
      ref.watch(ionConnectSyncEntityProvider(eventReference: repost.data.eventReference));
  if (entity == null) return false;
  return ref.watch(isEntityBlockedOrMutedOrBlockingProvider(entity));
}

@riverpod
class BlockListNotifier extends _$BlockListNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleBlocked(String pubkey) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentPubkey = ref.read(currentPubkeySelectorProvider);
      if (currentPubkey == null) {
        throw UserMasterPubkeyNotFoundException();
      }

      final blockList = await ref.read(currentUserBlockListProvider.future);
      final blockedPubkeys = Set<String>.from(blockList?.data.pubkeys ?? []);
      final isAlreadyBlocked = blockedPubkeys.contains(pubkey);

      if (isAlreadyBlocked) {
        blockedPubkeys.remove(pubkey);
      } else {
        blockedPubkeys.add(pubkey);
      }

      final blockListData = BlockListData(pubkeys: blockedPubkeys.toList());

      await Future.wait([
        ref.read(ionConnectNotifierProvider.notifier).sendEntitiesData([blockListData]),
        if (!isAlreadyBlocked) ...[
          ref.read(followListManagerProvider.notifier).unfollow(pubkey),
        ],
      ]);
    });
  }
}
