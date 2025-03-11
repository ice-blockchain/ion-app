// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';

class NotificationTypeIcon extends StatelessWidget {
  const NotificationTypeIcon({
    required this.notificationsType,
    required this.iconSize,
    super.key,
  });

  final NotificationsType notificationsType;

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: iconSize,
      height: iconSize,
      padding: EdgeInsets.all(6.0.s),
      decoration: BoxDecoration(
        color: notificationsType.getBackgroundColor(context),
        borderRadius: BorderRadius.circular(10.0.s),
      ),
      child: notificationsType.iconAsset.icon(size: 18.0.s, color: Colors.white),
    );
  }
}
