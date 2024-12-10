// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/follow_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/follower_counters/profile_followers_cell.dart';

class ProfileFollowers extends ConsumerWidget {
  const ProfileFollowers({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 44.0.s,
      decoration: BoxDecoration(
        color: context.theme.appColors.tertararyBackground,
        borderRadius: BorderRadius.circular(16.0.s),
      ),
      child: Row(
        children: [
          Expanded(
            child: ProfileFollowersCell(
              pubkey: pubkey,
              followType: FollowType.following,
            ),
          ),
          VerticalDivider(
            width: 1.0.s,
            thickness: 0.5.s,
            indent: 8.0.s,
            endIndent: 8.0.s,
            color: context.theme.appColors.onTerararyFill,
          ),
          Expanded(
            child: ProfileFollowersCell(
              pubkey: pubkey,
              followType: FollowType.followers,
            ),
          ),
        ],
      ),
    );
  }
}
