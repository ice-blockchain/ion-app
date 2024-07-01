import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/description_list_item.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/mocked_notifications.dart';
import 'package:ice/app/features/auth/views/pages/turn_on_notifications/notification_list_item.dart';
import 'package:ice/app/features/core/providers/permissions_provider.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TurnOnNotifications extends IceSimplePage {
  const TurnOnNotifications(super.route, super.payload, {super.key});

  void handleSignIn(WidgetRef ref) {
    ref.read(authProvider.notifier).signIn(
          email: 'foo@bar.baz',
          password: '123',
        );
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, void payload) {
    final iconSide = 27.0.s;

    return SheetContent(
      backgroundColor: context.theme.appColors.secondaryBackground,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 16.0.s),
            child: AuthHeader(
              title: context.i18n.turn_notifications_title,
              description: context.i18n.turn_notifications_description,
              sidePadding: 12.0.s,
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
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(height: 48.0.s),
                      DescriptionListItem(
                        title: context.i18n.turn_notifications_receive,
                        icon: Assets.images.icons.iconButtonReceive.icon(
                          color: context.theme.appColors.primaryText,
                          fit: BoxFit.contain,
                          size: iconSide,
                        ),
                      ),
                      SizedBox(height: 20.0.s),
                      DescriptionListItem(
                        title: context.i18n.turn_notifications_stay_up,
                        icon: Assets.images.icons.iconFeedStories.icon(
                          color: context.theme.appColors.primaryText,
                          size: iconSide,
                        ),
                      ),
                      SizedBox(height: 20.0.s),
                      DescriptionListItem(
                        title: context.i18n.turn_notifications_chat,
                        icon: Assets.images.icons.iconChatOff.icon(
                          color: context.theme.appColors.primaryText,
                          size: iconSide,
                        ),
                      ),
                      SizedBox(height: 76.0.s),
                      ScreenSideOffset.small(
                        child: Button(
                          label: Text(context.i18n.button_continue),
                          mainAxisSize: MainAxisSize.max,
                          onPressed: () {
                            ref
                                .read(permissionsProvider.notifier)
                                .requestPermission(
                                  PermissionType.Notifications,
                                )
                                .then((_) => handleSignIn(ref));
                          },
                        ),
                      ),
                      SizedBox(height: 50.0.s),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
