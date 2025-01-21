// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/components/empty_state_copy_link.dart';
import 'package:ion/app/features/chat/community/providers/community_metadata_provider.c.dart';
import 'package:ion/app/features/chat/community/view/components/joined_users_amount_tile.dart';
import 'package:ion/app/features/chat/components/messaging_header/messaging_header.dart';
import 'package:ion/app/features/chat/messages/views/components/components.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelPage extends ConsumerWidget {
  const ChannelPage({
    required this.uuid,
    super.key,
  });

  final String uuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final channel = ref.watch(communityMetadataProvider(uuid)).valueOrNull;
    if (channel == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: SafeArea(
        minimum: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom > 0 ? 17.0.s : 0,
        ),
        bottom: false,
        child: Column(
          children: [
            MessagingHeader(
              onTap: () => ChannelDetailRoute(uuid: uuid).push<void>(context),
              imageWidget: channel.avatar?.url != null ? Image.network(channel.avatar!.url) : null,
              name: channel.name,
              subtitle: CommunityMemberCountTile(
                communityUUID: channel.uuid,
              ),
            ),
            MessagingEmptyView(
              title: context.i18n.common_invitation_link,
              asset: Assets.svg.iconChatEmptystate,
              trailing: const EmptyStateCopyLink(link: 'htps://ice.io/iceofficialchannel'),
              leading: Column(
                children: [
                  SizedBox(height: 12.0.s),
                  const ChatDateHeaderText(),
                  SizedBox(height: 12.0.s),
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
    );
  }
}
