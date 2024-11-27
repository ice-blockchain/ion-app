// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/user/pages/components/user_name_tile/user_name_tile.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/followed_by/followed_by.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_about.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/edit_user_button.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/profile_actions.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_followers.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/user_info/user_info_summary.dart';

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCurrentUserProfile = ref.watch(isCurrentUserSelectorProvider(pubkey));

    return ScreenSideOffset.small(
      child: Column(
        children: [
          UserNameTile(pubkey: pubkey),
          SizedBox(height: 8.0.s),
          if (isCurrentUserProfile)
            const EditUserButton()
          else
            ProfileActions(
              pubkey: pubkey,
            ),
          SizedBox(height: 16.0.s),
          ProfileFollowers(
            pubkey: pubkey,
          ),
          SizedBox(height: 10.0.s),
          FollowedBy(pubkey: pubkey),
          SizedBox(height: 12.0.s),
          ProfileAbout(pubkey: pubkey),
          SizedBox(height: 12.0.s),
          UserInfoSummary(pubkey: pubkey),
        ],
      ),
    );
  }
}
