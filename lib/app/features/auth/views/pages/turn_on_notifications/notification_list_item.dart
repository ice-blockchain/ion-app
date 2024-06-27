import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/mocked_notifications.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    required this.notification,
    super.key,
  });

  final MockedNotification notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 43.0.s),
      child: ListItem.user(
        context: context,
        profilePictureIceBadge: notification.iceVerified,
        title: Text(
          notification.title,
          style: context.theme.appTextThemes.body.copyWith(
            color: context.theme.appColors.secondaryBackground,
          ),
        ),
        subtitle: Text(
          notification.description,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.secondaryBackground,
          ),
        ),
        profilePictureWidget: notification.image,
        backgroundColor: context.theme.appColors.primaryAccent,
        contentPadding: EdgeInsets.all(12.0.s),
        borderRadius: BorderRadius.circular(16.0.s),
        trailing: Text(
          notification.time,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.tertararyBackground,
          ),
        ),
        trailingPadding: EdgeInsets.only(left: 6.0.s),
      ),
    );
  }
}
