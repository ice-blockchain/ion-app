// SPDX-License-Identifier: ice License 1.0

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/features/chat/providers/channels_provider.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/empty_state_copy_link.dart';
import 'package:ion/app/features/chat/views/pages/components/joined_users_amount_tile.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/services/keyboard/keyboard.dart';
import 'package:ion/generated/assets.gen.dart';

const String hasPrivacyModalShownKey = 'hasPrivacyModalShownKey';

class ChannelPage extends ConsumerWidget {
  const ChannelPage({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channelData = ref.watch(channelsProvider.select((channelMap) => channelMap[pubkey]));
    if (channelData == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Scaffold(
        backgroundColor: context.theme.appColors.secondaryBackground,
        body: SafeArea(
          minimum: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
          ),
          bottom: false,
          child: Column(
            children: [
              MessagingHeader(
                onTap: () => EditChannelRoute(pubkey: pubkey).push<void>(context),
                imageWidget:
                    channelData.image != null ? Image.file(File(channelData.image!.path)) : null,
                name: channelData.name,
                subtitle: JoinedUsersAmountTile(
                  amount: channelData.users.length,
                ),
              ),
              MessagingEmptyView(
                title: context.i18n.common_invitation_link,
                asset: Assets.svg.iconChatEmptystate,
                trailing: EmptyStateCopyLink(link: channelData.link),
                leading: Column(
                  children: [
                    const ChatDateHeaderText(),
                    Text(
                      context.i18n.channel_created_message,
                      style: context.theme.appTextThemes.caption2.copyWith(
                        color: context.theme.appColors.tertararyText,
                      ),
                    ),
                  ],
                ),
              ),
              const MessagingBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
