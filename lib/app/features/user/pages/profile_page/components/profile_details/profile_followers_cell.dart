// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/pages/profile_page/types/follow_type.dart';
import 'package:ice/app/features/user/providers/user_followers_provider.dart';
import 'package:ice/app/features/user/providers/user_following_provider.dart';

class ProfileFollowersCell extends ConsumerWidget {
  const ProfileFollowersCell({
    required this.pubkey,
    required this.followType,
    super.key,
  });

  final String pubkey;
  final FollowType followType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFollowersNumber = ref.watch(userFollowersProvider(pubkey)).valueOrNull?.length ?? 0;
    final userFollowingNumber = ref.watch(userFollowingProvider(pubkey)).valueOrNull?.length ?? 0;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          followType.iconAsset.icon(
            color: context.theme.appColors.primaryText,
            size: 16.0.s,
          ),
          SizedBox(width: 4.0.s),
          Text(
            '${followType == FollowType.following ? userFollowingNumber : userFollowersNumber}',
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.primaryText,
            ),
          ),
          SizedBox(width: 4.0.s),
          Text(
            followType.getTitle(context),
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.tertararyText,
            ),
          ),
        ],
      ),
    );
  }
}
