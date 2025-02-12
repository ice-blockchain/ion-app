// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_list_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<FollowListEntity?> followList(
  Ref ref,
  String pubkey, {
  bool network = true,
  bool cache = true,
}) async {
  final entityProvider = ionConnectEntityProvider(
    eventReference: ReplaceableEventReference(pubkey: pubkey, kind: FollowListEntity.kind),
    network: network,
    cache: cache,
  );

  ref.onDispose(
    () => ref.invalidate(entityProvider),
  );

  return await ref.watch(entityProvider.future) as FollowListEntity?;
}

@Riverpod(keepAlive: true)
Future<FollowListEntity?> currentUserFollowList(Ref ref) async {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);
  if (currentPubkey == null) {
    return null;
  }
  ref.onDispose(() => ref.invalidate(followListProvider(currentPubkey, cache: false)));
  return ref.watch(followListProvider(currentPubkey, cache: false).future);
}

@riverpod
bool isCurrentUserFollowingSelector(Ref ref, String pubkey) {
  return ref.watch(
    currentUserFollowListProvider.select(
      (state) => state.valueOrNull?.data.list.any((followee) => followee.pubkey == pubkey) ?? false,
    ),
  );
}

@riverpod
bool isCurrentUserFollowed(Ref ref, String pubkey) {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider).valueOrNull;
  return ref.watch(
    followListProvider(pubkey).select(
      (state) =>
          state.valueOrNull?.data.list.any((followee) => followee.pubkey == currentPubkey) ?? false,
    ),
  );
}

@riverpod
class FollowListManager extends _$FollowListManager {
  @override
  FutureOr<void> build() async {}

  Future<void> toggleFollow(String pubkey) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final followList = await ref.read(currentUserFollowListProvider.future);
      if (followList == null) {
        throw FollowListNotFoundException();
      }
      await _toggleFollow(pubkey, followList);
    });
  }

  Future<void> unfollow(String pubkey) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final followList = await ref.read(currentUserFollowListProvider.future);
      if (followList == null) {
        throw FollowListNotFoundException();
      }
      await _toggleFollow(pubkey, followList, removeOnly: true);
    });
  }

  Future<void> _toggleFollow(
    String pubkey,
    FollowListEntity followListEntity, {
    bool removeOnly = false,
  }) async {
    final followees = List<Followee>.from(followListEntity.data.list);
    final followee = followees.firstWhereOrNull((followee) => followee.pubkey == pubkey);
    if (followee == null && removeOnly) {
      return;
    } else if (followee != null) {
      followees.remove(followee);
    } else {
      followees.add(Followee(pubkey: pubkey));
    }
    await ref
        .read(ionConnectNotifierProvider.notifier)
        .sendEntityData(followListEntity.data.copyWith(list: followees));
  }
}
