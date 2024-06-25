import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/mocked_notifications.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/notification_list_item.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

class TurnOnNotifications extends IceSimplePage {
  const TurnOnNotifications(super.route, super.payload, {super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16.0.s),
            child: AuthHeader(
              title: context.i18n.turn_notifications_title,
              description: context.i18n.turn_notifications_description,
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList.separated(
                  separatorBuilder: (BuildContext _, int __) => SizedBox(
                    height: 8.0.s,
                  ),
                  itemCount: mockedNotifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    final notification = mockedNotifications[index];

                    return NotificationListItem(
                      notification: notification,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
