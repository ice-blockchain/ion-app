// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/repost_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/ion_connect/model/action_source.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_cache.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/block_list.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'block_list_notifier.c.g.dart';

@riverpod
Future<BlockListEntity?> blockList(
  Ref ref,
  String pubkey, {
  bool cacheOnly = false,
}) async {
  final cacheKey = BlockListEntity.cacheKeyBuilder(pubkey: pubkey);
  final blockList = ref.watch(
    ionConnectCacheProvider.select(cacheSelector<BlockListEntity>(cacheKey)),
  );

  if (blockList != null || cacheOnly) {
    return blockList;
  }

  final requestMessage = RequestMessage()
    ..addFilter(
      RequestFilter(
        kinds: const [BlockListEntity.kind],
        authors: [pubkey],
      ),
    );

  return ref.watch(ionConnectNotifierProvider.notifier).requestEntity(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
}

@riverpod
Future<BlockListEntity?> currentUserBlockList(Ref ref) async {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);
  if (currentPubkey == null) {
    return null;
  }
  return ref.watch(blockListProvider(currentPubkey).future);
}

@riverpod
Future<bool> isBlocked(Ref ref, String pubkey) async {
  final currentBlockList = await ref.watch(currentUserBlockListProvider.future);
  return currentBlockList?.data.pubkeys.contains(pubkey) ?? false;
}

@riverpod
Future<bool> isBlocking(Ref ref, String pubkey, {bool cacheOnly = false}) async {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);
  if (currentPubkey == null) {
    return false;
  }
  final otherUserBlockList =
      await ref.watch(blockListProvider(pubkey, cacheOnly: cacheOnly).future);
  return otherUserBlockList?.data.pubkeys.contains(currentPubkey) ?? false;
}

@riverpod
Future<bool> isBlockedOrBlocking(Ref ref, String pubkey, {bool cacheOnly = false}) async {
  final results = await Future.wait([
    ref.watch(isBlockedProvider(pubkey).future),
    ref.watch(isBlockingProvider(pubkey, cacheOnly: cacheOnly).future),
  ]);
  return results[0] || results[1];
}

@riverpod
Future<bool> isEntityBlockedOrBlocking(
  Ref ref,
  IonConnectEntity entity, {
  bool cacheOnly = false,
}) async {
  final isMainAuthorBlockedOrBlocking = ref
          .watch(isBlockedOrBlockingProvider(entity.masterPubkey, cacheOnly: cacheOnly))
          .valueOrNull ??
      true;
  if (isMainAuthorBlockedOrBlocking) return true;
  return switch (entity) {
    PostEntity() => isPostChildBlockedOrBlocking(ref, entity, cacheOnly: cacheOnly),
    RepostEntity() => isRepostChildBlockedOrBlocking(ref, entity, cacheOnly: cacheOnly),
    GenericRepostEntity() =>
      isGenericRepostChildBlockedOrBlocking(ref, entity, cacheOnly: cacheOnly),
    _ => false,
  };
}

@riverpod
Future<bool> isPostChildBlockedOrBlocking(
  Ref ref,
  PostEntity entity, {
  bool cacheOnly = false,
}) async {
  final quotedEvent = entity.data.quotedEvent;
  if (quotedEvent == null) return false;
  final quotedPostReference = ImmutableEventReference(
    eventId: quotedEvent.eventId,
    pubkey: quotedEvent.pubkey,
  );
  final quotedPost = await ref.watch(
    ionConnectEntityProvider(eventReference: quotedPostReference).future,
  );
  if (quotedPost == null) return true;
  return ref
          .watch(isEntityBlockedOrBlockingProvider(quotedPost, cacheOnly: cacheOnly))
          .valueOrNull ??
      true;
}

@riverpod
Future<bool> isRepostChildBlockedOrBlocking(
  Ref ref,
  RepostEntity repost, {
  bool cacheOnly = false,
}) async {
  final eventReference =
      ImmutableEventReference(eventId: repost.data.eventId, pubkey: repost.data.pubkey);
  final entity = await ref.watch(ionConnectEntityProvider(eventReference: eventReference).future);
  if (entity == null) return true;
  return ref.watch(isEntityBlockedOrBlockingProvider(entity, cacheOnly: cacheOnly)).valueOrNull ??
      true;
}

@riverpod
Future<bool> isGenericRepostChildBlockedOrBlocking(
  Ref ref,
  GenericRepostEntity repost, {
  bool cacheOnly = false,
}) async {
  final eventReference =
      ImmutableEventReference(eventId: repost.data.eventId, pubkey: repost.data.pubkey);
  final entity = await ref.watch(ionConnectEntityProvider(eventReference: eventReference).future);
  if (entity == null) return true;
  return ref.watch(isEntityBlockedOrBlockingProvider(entity, cacheOnly: cacheOnly)).valueOrNull ??
      true;
}

@riverpod
class BlockListNotifier extends _$BlockListNotifier {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleBlocked(String pubkey) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final currentPubkey = await ref.read(currentPubkeySelectorProvider.future);
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
