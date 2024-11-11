// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/notifications/notification_data.dart';
import 'package:ion/app/features/feed/views/pages/notifications_history_page/components/notification_item/notification_info.dart';
import 'package:ion/app/features/feed/views/pages/notifications_history_page/components/notification_item/notification_type_icon.dart';
import 'package:ion/app/features/feed/views/pages/notifications_history_page/components/notification_item/user_avatar.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notificationData,
    super.key,
  });

  final NotificationData notificationData;

  static double get padding => 16.0.s;

  static double get separator => 4.0.s;

  static int get iconsCount => 10;

  @override
  Widget build(BuildContext context) {
    final iconSize =
        ((MediaQuery.of(context).size.width - padding * 2) - separator * (iconsCount - 1)) /
            iconsCount;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NotificationTypeIcon(
                notificationsType: notificationData.type,
                iconSize: iconSize,
              ),
              ...notificationData.userPubkeys.take(iconsCount - 1).map((pubkey) {
                return Padding(
                  padding: EdgeInsets.only(left: separator),
                  child: UserAvatar(
                    pubkey: pubkey,
                    avatarSize: iconSize,
                  ),
                );
              }),
            ],
          ),
          SizedBox(
            height: 8.0.s,
          ),
          NotificationInfo(notificationData: notificationData),
        ],
      ),
    );
  }
}
