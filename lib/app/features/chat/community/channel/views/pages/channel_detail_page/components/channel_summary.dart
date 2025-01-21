// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_detail_page/components/channel_name_tile.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/components/channel_avatar.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/components/share_link_tile.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/views/pages/components/joined_users_amount_tile.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelSummary extends HookConsumerWidget {
  const ChannelSummary({
    required this.channel,
    this.basicMode = false,
    super.key,
  });

  final CommunityDefinitionData channel;
  final bool basicMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider).requireValue;

    final hasAccessToEdit = useMemoized(
      () => channel.admins.contains(currentUserPubkey) || (channel.owner == currentUserPubkey),
      [channel, currentUserPubkey],
    );

    return Column(
      children: [
        SizedBox(
          height: 40.0.s,
        ),
        ChannelAvatar(
          channel: channel,
          editMode: basicMode,
        ),
        SizedBox(
          height: 10.0.s,
        ),
        ChannelNameTile(
          name: channel.name,
        ),
        SizedBox(height: 2.0.s),
        JoinedUsersAmountTile(
          channelUUID: channel.uuid,
        ),
        if (!basicMode)
          if (hasAccessToEdit) ...[
            Padding(
              padding: EdgeInsets.only(top: 16.0.s, bottom: 20.0.s),
              child: Button(
                onPressed: () {
                  EditChannelRoute(uuid: channel.uuid).push<void>(context);
                },
                leadingIcon: Assets.svg.iconEditLink.icon(
                  color: context.theme.appColors.onPrimaryAccent,
                  size: 16.0.s,
                ),
                tintColor: context.theme.appColors.primaryAccent,
                label: Text(
                  context.i18n.channel_edit,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.secondaryBackground,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(87.0.s, 28.0.s),
                  padding: EdgeInsets.symmetric(horizontal: 18.0.s),
                ),
              ),
            ),
          ] else
            SizedBox(height: 24.0.s)
        else
          SizedBox(height: 20.0.s),
        ChannelDetailListTile(
          title: context.i18n.common_share_link,
          //TODO: add link
          subtitle: 'htps://ice.io/iceofficialchannel',
          trailing: Assets.svg.iconBlockCopyBlue.icon(
            size: 20.0.s,
            color: context.theme.appColors.primaryAccent,
          ),
          onTap: () => copyToClipboard('htps://ice.io/iceofficialchannel'),
        ),
        if (!basicMode) ...[
          SizedBox(height: 12.0.s),
          ChannelDetailListTile(
            title: context.i18n.common_desc,
            subtitle: channel.description ?? '',
          ),
        ],
      ],
    );
  }
}
