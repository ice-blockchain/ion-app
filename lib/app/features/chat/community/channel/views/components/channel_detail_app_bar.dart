// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/features/chat/community/models/entities/community_definition_data.f.dart';
import 'package:ion/app/features/user/pages/components/header_action/header_action.dart';
import 'package:ion/generated/assets.gen.dart';

class ChannelDetailAppBar extends StatelessWidget {
  const ChannelDetailAppBar({
    required this.channel,
    super.key,
  });

  final CommunityDefinitionData channel;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderAction(
            onPressed: () {
              context.pop();
            },
            assetName: Assets.svg.iconProfileBack,
            flipForRtl: true,
            opacity: 1,
          ),
          HeaderAction(
            onPressed: () {},
            assetName: Assets.svg.iconMorePopup,
            opacity: 1,
          ),
        ],
      ),
    );
  }
}
