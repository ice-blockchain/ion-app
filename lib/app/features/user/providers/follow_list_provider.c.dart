// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.c.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.c.dart';
import 'package:ion/app/features/user/model/follow_list.c.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_list_provider.c.g.dart';

@Riverpod(keepAlive: true)
Future<FollowListEntity?> followList(Ref ref, String pubkey) async {
  final followList = ref.watch(
    nostrCacheProvider
        .select(cacheSelector<FollowListEntity>(FollowListEntity.cacheKeyBuilder(pubkey: pubkey))),
  );
  if (followList != null) {
    return followList;
  }

  final requestMessage = RequestMessage()
    ..addFilter(RequestFilter(kinds: const [FollowListEntity.kind], authors: [pubkey], limit: 1));
  return ref.read(nostrNotifierProvider.notifier).requestEntity<FollowListEntity>(
        requestMessage,
        actionSource: ActionSourceUser(pubkey),
      );
}

@Riverpod(keepAlive: true)
Future<FollowListEntity?> currentUserFollowList(Ref ref) async {
  final currentPubkey = await ref.watch(currentPubkeySelectorProvider.future);
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
      final followees = List<Followee>.from(followList.data.list);
      final followee = followees.firstWhereOrNull((followee) => followee.pubkey == pubkey);
      if (followee != null) {
        followees.remove(followee);
      } else {
        followees.add(Followee(pubkey: pubkey));
      }
      await ref
          .read(nostrNotifierProvider.notifier)
          .sendEntityData(followList.data.copyWith(list: followees));
    });
  }
}
