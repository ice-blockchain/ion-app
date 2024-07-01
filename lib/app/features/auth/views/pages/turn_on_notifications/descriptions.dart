import 'package:flutter/material.dart';
import 'package:ice/app/components/separated/separated_column.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/description_list_item.dart';
import 'package:ice/generated/assets.gen.dart';

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
          icon: Assets.images.icons.iconButtonReceive.icon(
            color: context.theme.appColors.primaryText,
            size: iconSide,
          ),
        ),
        DescriptionListItem(
          title: context.i18n.turn_notifications_stay_up,
          icon: Assets.images.icons.iconFeedStories.icon(
            color: context.theme.appColors.primaryText,
            size: iconSide,
          ),
        ),
        DescriptionListItem(
          title: context.i18n.turn_notifications_chat,
          icon: Assets.images.icons.iconChatOff.icon(
            color: context.theme.appColors.primaryText,
            size: iconSide,
          ),
        ),
      ],
    );
  }
}
