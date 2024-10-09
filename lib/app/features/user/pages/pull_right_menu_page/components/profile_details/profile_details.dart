// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/decorations.dart';
import 'package:ice/app/features/user/pages/pull_right_menu_page/components/profile_details/profile_details_cell.dart';
import 'package:ice/app/features/user/providers/user_followers_provider.dart';
import 'package:ice/app/features/user/providers/user_following_provider.dart';
import 'package:ice/app/features/user/providers/user_metadata_provider.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({
    super.key,
  });

  double get verifiedIconSize => 16.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdSelectorProvider);
    final userMetadataValue = ref.watch(currentUserMetadataProvider).valueOrNull;
    final userFollowers = ref.watch(userFollowersProvider(currentUserId));
    final userFollowing = ref.watch(userFollowingProvider(currentUserId));

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40.0.s),
      height: 164.0.s,
      decoration: Decorations.borderBoxDecoration(context),
      child: userMetadataValue != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userMetadataValue.displayName,
                      style: context.theme.appTextThemes.title.copyWith(
                        color: context.theme.appColors.primaryText,
                      ),
                    ),
                    if (userMetadataValue.verified) ...[
                      SizedBox(width: 6.0.s),
                      Assets.svg.iconBadgeVerify.icon(size: verifiedIconSize),
                    ],
                  ],
                ),
                SizedBox(height: 3.0.s),
                Text(
                  prefixUsername(username: userMetadataValue.name, context: context),
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.secondaryText,
                  ),
                ),
                SizedBox(height: 20.0.s),
                SizedBox(
                  height: 45.0.s,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileDetailsCell(
                        title: context.i18n.profile_following,
                        value: userFollowing.valueOrNull?.length,
                      ),
                      VerticalDivider(
                        width: 36.0.s,
                        thickness: 1.0.s,
                        color: context.theme.appColors.onTerararyFill,
                      ),
                      ProfileDetailsCell(
                        title: context.i18n.profile_followers,
                        value: userFollowers.valueOrNull?.length,
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
