// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/avatar/avatar.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/pages/components/user_name_tile/user_name_tile.dart';
import 'package:ice/app/features/user/pages/profile_page/components/decorations.dart';
import 'package:ice/app/features/user/pages/profile_page/components/profile_details/followed_by/followed_by.dart';
import 'package:ice/app/features/user/pages/profile_page/components/profile_details/profile_about.dart';
import 'package:ice/app/features/user/pages/profile_page/components/profile_details/profile_actions.dart';
import 'package:ice/app/features/user/pages/profile_page/components/profile_details/profile_followers.dart';
import 'package:ice/app/features/user/pages/profile_page/components/profile_details/user_info/user_info.dart';
import 'package:ice/app/features/user/providers/user_metadata_provider.dart';

class ProfileDetails extends ConsumerWidget {
  const ProfileDetails({
    required this.pubkey,
    super.key,
  });

  double get pictureSize => 100.0.s;

  double get pictureBorderWidth => 5.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataValue = ref.watch(userMetadataProvider(pubkey)).valueOrNull;

    if (userMetadataValue == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          alignment: Alignment.topCenter,
          decoration: Decorations.borderBoxDecoration(context),
          child: ScreenSideOffset.small(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: pictureSize * 0.6 + 11.0.s),
                UserNameTile(pubkey: pubkey),
                SizedBox(height: 8.0.s),
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
                UserInfo(pubkey: pubkey),
              ],
            ),
          ),
        ),
        Positioned(
          top: -pictureSize * 0.4,
          child: Container(
            padding: EdgeInsets.all(pictureBorderWidth),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0.s),
            ),
            child: Avatar(
              size: pictureSize - pictureBorderWidth * 2,
              fit: BoxFit.cover,
              imageUrl: userMetadataValue.picture,
              borderRadius: BorderRadius.circular(20.0.s),
            ),
          ),
        ),
      ],
    );
  }
}
