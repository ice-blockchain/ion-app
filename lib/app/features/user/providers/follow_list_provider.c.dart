// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/ion_connect/data/models/action_source.c.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_notifier.c.dart';
import 'package:ion/app/features/user/data/models/follow_list.c.dart';
import 'package:ion/app/features/user/providers/user_events_metadata_provider.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_list_provider.c.g.dart';

@riverpod
Future<FollowListEntity?> followList(
  Ref ref,
  String pubkey, {
  bool network = true,
  bool cache = true,
}) async {
  return await ref.watch(
    ionConnectEntityProvider(
      eventReference: ReplaceableEventReference(pubkey: pubkey, kind: FollowListEntity.kind),
      network: network,
      cache: cache,
    ).future,
  ) as FollowListEntity?;
}

@riverpod
Future<FollowListEntity?> currentUserFollowList(Ref ref) async {
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
  if (currentPubkey == null) {
    return null;
  }
  return ref.watch(followListProvider(currentPubkey).future);
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
  final currentPubkey = ref.watch(currentPubkeySelectorProvider);
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
    final currentUserPubkey = ref.read(currentPubkeySelectorProvider);

    // Remove current user from the list to prevent self follow error
    // TODO: delete it after the release
    followees.removeWhere((followee) => followee.pubkey == currentUserPubkey);

    final followee = followees.firstWhereOrNull((followee) => followee.pubkey == pubkey);
    if (followee == null && removeOnly) {
      return;
    } else if (followee != null) {
      followees.remove(followee);
    } else {
      followees.add(Followee(pubkey: pubkey));
    }

    final ionNotifier = ref.read(ionConnectNotifierProvider.notifier);
    final updatedFollowList = followListEntity.data.copyWith(list: followees);
    final updatedFollowListEvent = await ionNotifier.sign(updatedFollowList);
    final userEventsMetadataBuilder = await ref.read(userEventsMetadataBuilderProvider.future);

    await Future.wait([
      ionNotifier.sendEvent(updatedFollowListEvent),
      ionNotifier.sendEvent(
        updatedFollowListEvent,
        actionSource: ActionSourceUser(pubkey),
        metadataBuilders: [userEventsMetadataBuilder],
        cache: false,
      ),
    ]);
  }
}
