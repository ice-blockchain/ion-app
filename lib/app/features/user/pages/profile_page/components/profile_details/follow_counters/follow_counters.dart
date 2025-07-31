// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/follow_counters/follow_counters_cell.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/followers_count_provider.r.dart';

class FollowCounters extends ConsumerWidget {
  const FollowCounters({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followListAsync = ref.watch(followListProvider(pubkey));
    final followersCountAsync = ref.watch(followersCountProvider(pubkey));
    final followingNumber = followListAsync.valueOrNull?.data.list.length;
    final followersNumber = followersCountAsync.valueOrNull;
    final bothAvailable = followingNumber != null && followersNumber != null;

    final isLoading = followListAsync.isLoading || followersCountAsync.isLoading;
    if (!isLoading && !bothAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 36.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.terararyBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: bothAvailable
                ? FollowCountersCell(
                    pubkey: pubkey,
                    usersNumber: followingNumber,
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
                    usersNumber: followersNumber,
                    followType: FollowType.followers,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
