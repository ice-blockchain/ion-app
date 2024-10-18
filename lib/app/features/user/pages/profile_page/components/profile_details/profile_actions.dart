// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/components/follow_user_button/follow_user_button.dart';
import 'package:ice/app/features/user/pages/profile_page/components/profile_details/profile_action.dart';
import 'package:ice/generated/assets.gen.dart';

class ProfileActions extends ConsumerWidget {
  const ProfileActions({
    required this.pubkey,
    super.key,
  });

  double get pictureSize => 100.0.s;

  double get pictureBorderWidth => 5.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FollowUserButton(
          userId: pubkey,
          showIcon: true,
        ),
        SizedBox(width: 8.0.s),
        ProfileAction(
          onPressed: () {},
          assetName: Assets.svg.iconProfileTips,
        ),
        SizedBox(width: 8.0.s),
        ProfileAction(
          onPressed: () {},
          assetName: Assets.svg.iconChatOff,
        ),
        SizedBox(width: 8.0.s),
        ProfileAction(
          onPressed: () {},
          assetName: Assets.svg.iconProfileNotificationOff,
        ),
      ],
    );
  }
}
