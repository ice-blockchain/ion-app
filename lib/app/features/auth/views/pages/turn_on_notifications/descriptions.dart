// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/auth/views/pages/turn_on_notifications/description_list_item.dart';
import 'package:ion/generated/assets.gen.dart';

class Descriptions extends StatelessWidget {
  const Descriptions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final iconSide = 27.0.s;

    return SeparatedColumn(
      separator: SizedBox(
        height: 20.0.s,
      ),
      children: [
        DescriptionListItem(
          title: context.i18n.turn_notifications_receive,
          icon: IconAssetColored(
            Assets.svgIconButtonReceive,
            color: context.theme.appColors.primaryText,
            size: iconSide,
          ),
        ),
        DescriptionListItem(
          title: context.i18n.turn_notifications_stay_up,
          icon: IconAssetColored(
            Assets.svgIconFeedStories,
            color: context.theme.appColors.primaryText,
            size: iconSide,
          ),
        ),
        DescriptionListItem(
          title: context.i18n.turn_notifications_chat,
          icon: IconAssetColored(
            Assets.svgIconChatOff,
            color: context.theme.appColors.primaryText,
            size: iconSide,
          ),
        ),
      ],
    );
  }
}
