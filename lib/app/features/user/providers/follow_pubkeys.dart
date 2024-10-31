// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.dart';
import 'package:ion/app/features/user/providers/user_followers_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_pubkeys.g.dart';

@riverpod
List<String>? followPubkeys(Ref ref, {required FollowType followType, required String pubkey}) {
  switch (followType) {
    case FollowType.followers:
      return ref.watch(userFollowersProvider(pubkey)).valueOrNull;
    case FollowType.following:
      {
        final followList = ref.watch(followListProvider(pubkey)).valueOrNull;
        return followList?.data.list.map((followee) => followee.pubkey).toList();
      }
  }
}
