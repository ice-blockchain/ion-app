// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/providers/user_chat_privacy_provider.r.dart';
import 'package:ion/app/features/components/user/follow_user_button/follow_user_button.dart';
import 'package:ion/app/features/user/model/user_notifications_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/profile_details/profile_actions/profile_action.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/account_notifications_modal/account_notifications_modal.dart';
import 'package:ion/app/features/user/providers/follow_list_provider.r.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.r.dart';
import 'package:ion/app/features/user/providers/user_specific_notifications_provider.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';
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
    final userNotificationsAsync = ref.watch(userSpecificNotificationsProvider(pubkey));
    final notificationsEnabled = userNotificationsAsync.maybeWhen(
      data: (types) => !types.contains(UserNotificationsType.none),
      orElse: () => false,
    );

    final walletsState = ref.watch(userMetadataProvider(pubkey).select((state) => state.value?.data.wallets));
    final hasPrivateWallets = walletsState == null;
    final following = ref.watch(isCurrentUserFollowingSelectorProvider(pubkey));
    final canSendMessage = ref.watch(canSendMessageProvider(pubkey, cache: false)).valueOrNull ?? false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FollowUserButton(pubkey: pubkey),
        SizedBox(width: 8.0.s),
        if (!hasPrivateWallets && canSendMessage) ...[
          ProfileAction(
            onPressed: () async {
              final needToEnable2FA = await PaymentSelectionProfileRoute(pubkey: pubkey).push<bool>(context);
              if (needToEnable2FA != null && needToEnable2FA && context.mounted) {
                await SecureAccountModalRoute().push<void>(context);
              }
            },
            assetName: Assets.svg.iconProfileTips,
          ),
        ],
        if (canSendMessage) ...[
          ProfileAction(
            onPressed: () {
              ConversationRoute(receiverMasterPubkey: pubkey).push<void>(context);
            },
            assetName: Assets.svg.iconChatOff,
          ),
          SizedBox(width: 8.0.s),
        ],
        if (following)
          ProfileAction(
            onPressed: () {
              showSimpleBottomSheet<void>(
                context: context,
                child: AccountNotificationsModal(
                  userPubkey: pubkey,
                ),
              );
            },
            isAccent: notificationsEnabled,
            assetName:
                notificationsEnabled ? Assets.svg.iconProfileNotificationOn : Assets.svg.iconProfileNotificationOff,
          ),
      ],
    );
  }
}
