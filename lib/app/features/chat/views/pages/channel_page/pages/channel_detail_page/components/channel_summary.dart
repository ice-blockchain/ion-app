import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/model/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/channel_avatar.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/components/share_link_tile.dart';
import 'package:ion/app/features/chat/views/pages/channel_page/pages/edit_channel_page/components/channel_name_tile.dart';
import 'package:ion/app/features/chat/views/pages/components/joined_users_amount_tile.dart';
import 'package:ion/app/services/clipboard/clipboard.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelSummary extends StatelessWidget {
  const ChannelSummary({
    required this.channel,
    required this.hasAccessToEdit,
    super.key,
  });

  final CommunityDefinitionData channel;
  final bool hasAccessToEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40.0.s,
        ),
        ChannelAvatar(
          channel: channel,
          hasAccessToEdit: hasAccessToEdit,
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
                //TODO: add link
                subtitle: 'htps://ice.io/iceofficialchannel',
                trailing: Assets.svg.iconBlockCopyBlue.icon(
                  size: 20.0.s,
                  color: context.theme.appColors.primaryAccent,
                ),
                onTap: () => copyToClipboard('htps://ice.io/iceofficialchannel'),
              ),
              if (!hasAccessToEdit)
                Padding(
                  padding: EdgeInsets.only(top: 12.0.s),
                  child: ChannelDetailListTile(
                    title: context.i18n.common_desc,
                    subtitle: channel.description ?? '',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
