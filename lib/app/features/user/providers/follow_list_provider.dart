// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/nostr/model/action_source.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/features/nostr/providers/nostr_notifier.dart';
import 'package:ion/app/features/user/model/follow_list.dart';
import 'package:nostr_dart/nostr_dart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_list_provider.g.dart';

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
      (state) => state.valueOrNull?.pubkeys.contains(pubkey) ?? false,
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
