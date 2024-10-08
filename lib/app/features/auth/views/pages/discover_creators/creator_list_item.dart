// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/components/follow_user_button/follow_user_button.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/username.dart';

class CreatorListItem extends ConsumerWidget {
  const CreatorListItem({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider(userId));

    return userData.maybeWhen(
      data: (userData) {
        return ScreenSideOffset.small(
          child: ListItem.user(
            title: Text(userData.displayName),
            subtitle: Text(prefixUsername(username: userData.name, context: context)),
            profilePicture: userData.picture,
            verifiedBadge: userData.verified,
            ntfAvatar: userData.nft,
            backgroundColor: context.theme.appColors.tertararyBackground,
            contentPadding: EdgeInsets.all(12.0.s),
            borderRadius: BorderRadius.circular(16.0.s),
            trailing: FollowUserButton(userId: userData.pubkey),
            trailingPadding: EdgeInsets.only(left: 6.0.s),
          ),
        );
      },
      orElse: () => ScreenSideOffset.small(child: Skeleton(child: ListItem())),
    );
  }
}
