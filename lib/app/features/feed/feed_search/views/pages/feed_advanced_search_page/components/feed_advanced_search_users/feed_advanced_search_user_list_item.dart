// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/components/follow_user_button/follow_user_button.dart';
import 'package:ice/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/username.dart';

class FeedAdvancedSearchUserListItem extends ConsumerWidget {
  const FeedAdvancedSearchUserListItem({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider(userId));
    final userDataValue = userData.valueOrNull;

    if (userDataValue == null) {
      return ScreenSideOffset.small(child: const Skeleton(child: PostSkeleton()));
    }

    final about = userDataValue.about;

    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.0.s),
          ListItem.user(
            title: Text(userDataValue.displayName ?? userDataValue.name ?? userDataValue.pubkey),
            subtitle: Text(
              prefixUsername(
                username: userDataValue.name ?? userDataValue.pubkey,
                context: context,
              ),
            ),
            ntfAvatar: userDataValue.nft,
            profilePicture: userDataValue.picture,
            verifiedBadge: userDataValue.verified,
            trailing: FollowUserButton(userId: userId),
          ),
          if (about != null) ...[
            SizedBox(height: 10.0.s),
            Text(
              about,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.sharkText,
              ),
            ),
          ],
          SizedBox(height: 12.0.s),
        ],
      ),
    );
  }
}
