// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/ion_connect_avatar/ion_connect_avatar.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class NotificationIcons extends StatelessWidget {
  const NotificationIcons({
    required this.notification,
    super.key,
  });

  final IonNotification notification;

  static double get separator => 4.0.s;

  static int get iconsCount => 10;

  @override
  Widget build(BuildContext context) {
    final iconSize = ((MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2) -
            separator * (iconsCount - 1)) /
        iconsCount;

    return Row(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          padding: EdgeInsets.all(6.0.s),
          decoration: BoxDecoration(
            color: notification.getBackgroundColor(context),
            borderRadius: BorderRadius.circular(10.0.s),
          ),
          child: IconAssetColored(notification.asset, color: Colors.white, size: 18),
        ),
        ...notification.pubkeys.take(iconsCount - 1).map((pubkey) {
          return Padding(
            padding: EdgeInsetsDirectional.only(start: separator),
            child: GestureDetector(
              onTap: () => ProfileRoute(pubkey: pubkey).push<void>(context),
              child: IonConnectAvatar(
                size: iconSize,
                fit: BoxFit.cover,
                pubkey: pubkey,
                borderRadius: BorderRadius.circular(10.0.s),
              ),
            ),
          );
        }),
      ],
    );
  }
}
