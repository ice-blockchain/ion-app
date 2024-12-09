// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/followed_by/followed_by_text.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/followed_by/user_avatar.dart';
import 'package:ion/app/features/user/providers/user_followers_provider.c.dart';

class FollowedBy extends ConsumerWidget {
  const FollowedBy({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userFollowers = ref.watch(userFollowersProvider(pubkey)).valueOrNull;

    if (userFollowers == null || userFollowers.isEmpty) {
      return const SizedBox.shrink();
    }

    final followersToDisplay = userFollowers.take(3).toList();

    final avatarSize = UserAvatar.avatarSize;
    final overlap = avatarSize * 0.2;

    return Row(
      children: [
        SizedBox(
          height: avatarSize,
          width: avatarSize + (followersToDisplay.length - 1) * (avatarSize - overlap),
          child: Stack(
            children: [
              for (int i = followersToDisplay.length - 1; i >= 0; i--)
                Positioned(
                  left: i * (avatarSize - overlap),
                  child: UserAvatar(
                    pubkey: followersToDisplay[i],
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          width: 10.0.s,
        ),
        FollowedByText(
          pubkey: pubkey,
        ),
      ],
    );
  }
}
