// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/follow_user_button/follow_user_button.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/profile_action.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/account_notifications_modal/account_notifications_modal.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class ProfileActions extends HookConsumerWidget {
  const ProfileActions({
    required this.pubkey,
    super.key,
  });

  double get pictureSize => 100.0.s;

  double get pictureBorderWidth => 5.0.s;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotificationsType = useState(UserNotificationsType.none);
    final notificationsEnabled = userNotificationsType.value != UserNotificationsType.none;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FollowUserButton(
          pubkey: pubkey,
        ),
        SizedBox(width: 8.0.s),
        ProfileAction(
          onPressed: () {
            PaymentSelectionRoute(pubkey: pubkey).push<void>(context);
          },
          assetName: Assets.svg.iconProfileTips,
        ),
        SizedBox(width: 8.0.s),
        ProfileAction(
          onPressed: () {},
          assetName: Assets.svg.iconChatOff,
        ),
        SizedBox(width: 8.0.s),
        ProfileAction(
          onPressed: () async {
            final newUserNotificationsType = await showSimpleBottomSheet<UserNotificationsType>(
              context: context,
              child: AccountNotificationsModal(
                selectedUserNotificationsType: userNotificationsType.value,
              ),
            );
            if (newUserNotificationsType != null) {
              userNotificationsType.value = newUserNotificationsType;
            }
          },
          isAccent: notificationsEnabled,
          assetName: notificationsEnabled
              ? Assets.svg.iconProfileNotificationOn
              : Assets.svg.iconProfileNotificationOff,
        ),
      ],
    );
  }
}
