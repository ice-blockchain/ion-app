// SPDX-License-Identifier: ice License 1.0

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.dart';
import 'package:ion/app/features/user/providers/user_followers_provider.dart';

({int count, List<String>? pubkeys}) useFollowListData(
  WidgetRef ref, {
  required FollowType followType,
  required String pubkey,
}) {
  switch (followType) {
    case FollowType.followers:
      {
        final followers = ref.watch(userFollowersProvider(pubkey)).valueOrNull;
        return (count: followers?.length ?? 0, pubkeys: followers);
      }
    case FollowType.following:
      {
        final followList = ref.watch(followListProvider(pubkey)).valueOrNull;
        return useMemoized(
          () {
            return (
              count: followList?.data.list.length ?? 0,
              pubkeys: followList?.data.list.map((followee) => followee.pubkey).toList()
            );
          },
          [followList],
        );
      }
  }
}
