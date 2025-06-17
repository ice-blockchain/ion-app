// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/views/pages/turn_on_notifications/notification_list_item.dart';
import 'package:ion/generated/assets.gen.dart';

class Notifications extends StatelessWidget {
  const Notifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final iconSide = 36.0.s;

    return SeparatedColumn(
      separator: SizedBox(
        height: 8.0.s,
      ),
      children: [
        NotificationListItem(
          iceVerified: true,
          image: Image.asset(
            Assets.imagesNotificationsAvatar1.path,
            width: iconSide,
            height: iconSide,
            fit: BoxFit.contain,
          ),
          title: context.i18n.turn_notifications_sent_title,
          description: context.i18n.turn_notifications_sent_description,
          time: context.i18n.turn_notifications_sent_time,
        ),
        NotificationListItem(
          image: Image.asset(
            Assets.imagesNotificationsAvatar2.path,
            width: iconSide,
            height: iconSide,
            fit: BoxFit.contain,
          ),
          title: context.i18n.turn_notifications_new_follower_title,
          description: context.i18n.turn_notifications_new_follower_description,
          time: context.i18n.turn_notifications_new_follower_time,
        ),
        NotificationListItem(
          image: Image.asset(
            Assets.imagesNotificationsAvatar3.path,
            width: iconSide,
            height: iconSide,
            fit: BoxFit.contain,
          ),
          title: context.i18n.turn_notifications_new_message_title,
          description: context.i18n.turn_notifications_new_message_description,
          time: context.i18n.turn_notifications_new_message_time,
        ),
      ],
    );
  }
}
