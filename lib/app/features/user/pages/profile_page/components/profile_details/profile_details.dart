// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/components/user/user_about/user_about.dart';
import 'package:ion/app/features/components/user/user_info_summary/user_info_summary.dart';
import 'package:ion/app/features/user/pages/components/user_name_tile/user_name_tile.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/follow_counters/follow_counters.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/edit_user_button.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/profile_actions.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/relevant_followers/relevant_followers.dart';

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
          if (isCurrentUserProfile) const EditUserButton() else ProfileActions(pubkey: pubkey),
          SizedBox(height: 16.0.s),
          FollowCounters(pubkey: pubkey),
          SizedBox(height: 10.0.s),
          if (!isCurrentUserProfile) ...[
            RelevantFollowers(pubkey: pubkey),
            SizedBox(height: 12.0.s),
          ],
          UserAbout(pubkey: pubkey, padding: EdgeInsets.only(bottom: 12.0.s)),
          UserInfoSummary(pubkey: pubkey),
        ],
      ),
    );
  }
}
