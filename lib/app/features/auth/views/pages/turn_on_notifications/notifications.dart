// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/separated/separated_column.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/notification_list_item.dart';
import 'package:ice/generated/assets.gen.dart';

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
          image: Assets.images.notifications.avatar1.icon(size: iconSide, fit: BoxFit.contain),
          title: context.i18n.turn_notifications_sent_title,
          description: context.i18n.turn_notifications_sent_description,
          time: context.i18n.turn_notifications_sent_time,
        ),
        NotificationListItem(
          image: Assets.images.notifications.avatar2.icon(size: iconSide),
          title: context.i18n.turn_notifications_new_follower_title,
          description: context.i18n.turn_notifications_new_follower_description,
          time: context.i18n.turn_notifications_new_follower_time,
        ),
        NotificationListItem(
          image: Assets.images.notifications.avatar3.icon(size: iconSide),
          title: context.i18n.turn_notifications_new_message_title,
          description: context.i18n.turn_notifications_new_message_description,
          time: context.i18n.turn_notifications_new_message_time,
        ),
      ],
    );
  }
}
