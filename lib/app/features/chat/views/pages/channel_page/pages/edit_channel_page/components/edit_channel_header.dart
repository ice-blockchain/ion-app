// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/screen_offset/screen_top_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/channel_avatar.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/share_link_tile.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/components/channel_name_tile.dart';
import 'package:ion/app/features/chat/views/pages/components/joined_users_amount_tile.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/generated/assets.gen.dart';

class EditChannelHeader extends StatelessWidget {
  const EditChannelHeader({
    required this.channel,
    super.key,
  });

  final CommunityDefinitionData channel;

  @override
  Widget build(BuildContext context) {
    return ScreenTopOffset(
      child: Column(
        children: [
          ScreenSideOffset.small(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  assetName: Assets.svg.iconProfileBack,
                  opacity: 1,
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40.0.s,
                    ),
                    ChannelAvatar(
                      channel: channel,
                    ),
                  ],
                ),
                HeaderAction(
                  onPressed: () {},
                  assetName: Assets.svg.iconMorePopup,
                  opacity: 1,
                ),
              ],
            ),
          ),
          ScreenSideOffset.large(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0.s,
                ),
                ChannelNameTile(
                  name: channel.name,
                ),
                SizedBox(height: 2.0.s),
                JoinedUsersAmountTile(
                  channelUuid: channel.uuid,
                ),
                SizedBox(height: 20.0.s),
                ChannelDetailListTile(
                  title: context.i18n.common_share_link,
                  subtitle: 'htps://ice.io/iceofficialchannel',
                  trailing: Assets.svg.iconBlockCopyBlue.icon(
                    size: 20.0.s,
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => copyToClipboard('htps://ice.io/iceofficialchannel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
