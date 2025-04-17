// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/follow_counters/follow_counters_cell.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.c.dart';

class FollowCounters extends ConsumerWidget {
  const FollowCounters({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingProvider = ref.watch(followListProvider(pubkey));
    final followersProvider = ref.watch(followersCountProvider(pubkey: pubkey));

    final followingAvailable = followingProvider.hasValue &&
        !followingProvider.hasError &&
        followingProvider.value != null;
    final followersAvailable = followersProvider.hasValue &&
        !followersProvider.hasError &&
        followersProvider.value != null;

    final bothAvailable = followingAvailable && followersAvailable;

    return Container(
      height: 36.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: bothAvailable
                ? FollowCountersCell(
                    pubkey: pubkey,
                    usersNumber: followingProvider.value!.data.list.length,
                    followType: FollowType.following,
                  )
                : const SizedBox.shrink(),
          ),
          VerticalDivider(
            width: 1.0.s,
            thickness: 0.5.s,
            indent: 8.0.s,
            endIndent: 8.0.s,
            color: context.theme.appColors.onTerararyFill,
          ),
          Expanded(
            child: bothAvailable
                ? FollowCountersCell(
                    pubkey: pubkey,
                    usersNumber: followersProvider.value!,
                    followType: FollowType.followers,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
