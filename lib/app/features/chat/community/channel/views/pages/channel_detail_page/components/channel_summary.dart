// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/copy/copy_builder.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/chat/community/channel/hooks/use_can_edit_channel.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/components/channel_avatar.dart';
import 'package:ion/app/features/chat/community/channel/views/pages/channel_page/components/channel_detail_list_tile.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.c.dart';
import 'package:ion/app/features/chat/community/view/components/community_member_count_tile.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelSummary extends HookConsumerWidget {
  const ChannelSummary({
    required this.channel,
    this.basicMode = false,
    super.key,
  });

  final CommunityDefinitionEntity channel;
  final bool basicMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserPubkey = ref.watch(currentPubkeySelectorProvider);

    final canEdit = useCanEditChannel(channel: channel, currentPubkey: currentUserPubkey);

    return Column(
      children: [
        SizedBox(
          height: 40.0.s,
        ),
        ChannelAvatar(
          channel: channel.data,
          editMode: basicMode,
        ),
        SizedBox(
          height: 10.0.s,
        ),
        Text(
          textAlign: TextAlign.center,
          channel.data.name,
          style: context.theme.appTextThemes.title.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
        SizedBox(height: 2.0.s),
        CommunityMemberCountTile(
          community: channel,
        ),
        if (!basicMode)
          if (canEdit) ...[
            Padding(
              padding: EdgeInsetsDirectional.only(top: 16.0.s, bottom: 20.0.s),
              child: Button(
                onPressed: () {
                  EditChannelRoute(uuid: channel.data.uuid).push<void>(context);
                },
                leadingIcon: Assets.svgIconEditLink.icon(
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
        CopyBuilder(
          defaultIcon: Assets.svgIconBlockCopyBlue.icon(
            size: 20.0.s,
            color: context.theme.appColors.primaryAccent,
          ),
          defaultText: context.i18n.button_copy,
          defaultBorderColor: context.theme.appColors.strokeElements,
          builder: (context, onCopy, content) {
            return ChannelDetailListTile(
              title: content.text,
              subtitle: channel.data.defaultInvitationLink,
              trailing: content.icon,
              onTap: () => onCopy(channel.data.defaultInvitationLink),
              borderColor: content.borderColor,
            );
          },
        ),
        if (!basicMode) ...[
          SizedBox(height: 12.0.s),
          ChannelDetailListTile(
            title: context.i18n.common_desc,
            subtitle: channel.data.description ?? '',
          ),
        ],
      ],
    );
  }
}
