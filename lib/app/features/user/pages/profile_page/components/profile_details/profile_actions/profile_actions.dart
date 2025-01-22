// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/user/follow_user_button/follow_user_button.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/profile_action.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/account_notifications_modal/account_notifications_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/providers/user_notifications_provider.c.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/utils/show_simple_bottom_sheet.dart';
import 'package:ion/generated/assets.gen.dart';

class ProfileActions extends ConsumerWidget {
  const ProfileActions({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotificationsTypes = ref.watch(userNotificationsNotifierProvider);
    final notificationsEnabled = !userNotificationsTypes.contains(UserNotificationsType.none);
    final isCurrentUserFollowed = ref.watch(isCurrentUserFollowedProvider(pubkey));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FollowUserButton(
          pubkey: pubkey,
          followLabel: isCurrentUserFollowed ? context.i18n.button_follow_back : null,
        ),
        SizedBox(width: 8.0.s),
        ProfileAction(
          onPressed: () async {
            final result = await PaymentSelectionRoute(pubkey: pubkey).push<bool>(context);
            if (result != null && result == true && context.mounted) {
              await SecureAccountModalRoute().push<void>(context);
            }
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
          onPressed: () {
            showSimpleBottomSheet<void>(
              context: context,
              child: AccountNotificationsModal(
                selectedUserNotificationsTypes: userNotificationsTypes,
              ),
            );
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
