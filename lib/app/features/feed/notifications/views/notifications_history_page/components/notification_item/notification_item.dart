// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_info.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_type_icon.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/user_avatar.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/router/app_routes.c.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });

  final IonConnectNotification notification;

  static double get separator => 4.0.s;

  static int get iconsCount => 10;

  @override
  Widget build(BuildContext context) {
    final iconSize = ((MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2) -
            separator * (iconsCount - 1)) /
        iconsCount;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenSideOffset.small(
            child: Row(
              children: [
                NotificationTypeIcon(
                  notificationsType: notification.type,
                  iconSize: iconSize,
                ),
                ...notification.pubkeys.take(iconsCount - 1).map((pubkey) {
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
          ),
          SizedBox(height: 8.0.s),
          ScreenSideOffset.small(
            child: NotificationInfo(notification: notification),
          ),
          if (notification.eventReference != null)
            GestureDetector(
              onTap: () {
                PostDetailsRoute(eventReference: notification.eventReference!.encode())
                    .push<void>(context);
              },
              child: Post(
                eventReference: notification.eventReference!,
                header: const SizedBox.shrink(),
                footer: const SizedBox.shrink(),
                topOffset: 6.0.s,
                headerOffset: 0,
              ),
            ),
        ],
      ),
    );
  }
}
