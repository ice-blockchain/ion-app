// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/user/pages/components/user_name_tile/user_name_tile.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/decorations.dart';
import 'package:ion/app/features/user/pages/pull_right_menu_page/components/profile_details/profile_details_cell.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.dart';
import 'package:ion/app/features/user/providers/user_followers_provider.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPubkey = ref.watch(currentPubkeySelectorProvider) ?? '';
    final userMetadataValue = ref.watch(currentUserMetadataProvider).valueOrNull;
    final userFollowers = ref.watch(userFollowersProvider(currentPubkey));
    final followList = ref.watch(followListProvider(currentPubkey));

    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40.0.s),
      height: 164.0.s,
      decoration: Decorations.borderBoxDecoration(context),
      child: userMetadataValue != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserNameTile(pubkey: currentPubkey),
                SizedBox(height: 20.0.s),
                SizedBox(
                  height: 45.0.s,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileDetailsCell(
                        title: context.i18n.profile_following,
                        value: followList.valueOrNull?.data.list.length,
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
