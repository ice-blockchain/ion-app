// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/permissions/data/models/permissions_types.dart';
import 'package:ion/app/features/core/permissions/providers/permissions_provider.c.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_aware_widget.dart';
import 'package:ion/app/features/core/permissions/views/components/permission_dialogs/permission_request_sheet.dart';
import 'package:ion/app/features/settings/components/selectable_options_group.dart';
import 'package:ion/app/features/settings/model/push_notifications_options.dart';
import 'package:ion/app/hooks/use_selected_state.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class PushNotificationsSettings extends HookConsumerWidget {
  const PushNotificationsSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLevelPermissionNotifier = useState<bool>(true);
    final hasPermissionOnDeviceLevel = ref.watch(hasPermissionProvider(Permission.notifications));
    final hasNotificationsPermission =
        hasPermissionOnDeviceLevel && appLevelPermissionNotifier.value;

    // TODO: Replace stub with implementation
    final (socialNotifications, toggleSocialNotification) =
        useSelectedState<SocialNotificationOption>(
      SocialNotificationOption.values,
    );
    final (chatNotifications, toggleChatNotification) = useSelectedState<ChatNotificationOption>(
      ChatNotificationOption.values,
    );
    final (walletNotifications, toggleWalletNotification) =
        useSelectedState<WalletNotificationOption>(
      WalletNotificationOption.values,
    );
    final (systemNotifications, toggleSystemNotification) =
        useSelectedState<SystemNotificationOption>(
      SystemNotificationOption.values,
    );

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.settings_push_notifications),
            actions: const [
              NavigationCloseButton(),
            ],
          ),
          Expanded(
            child: ScreenBottomOffset(
              margin: 40.0.s,
              child: SingleChildScrollView(
                child: ScreenSideOffset.small(
                  child: SeparatedColumn(
                    separator: SelectableOptionsGroup.separator,
                    children: [
                      _DevicePermissionButton(
                        hasPermission: hasNotificationsPermission,
                        hasPermissionOnDeviceLevel: hasPermissionOnDeviceLevel,
                        onChangeAppLevelPermission: () {
                          appLevelPermissionNotifier.value = !appLevelPermissionNotifier.value;
                        },
                      ),
                      SelectableOptionsGroup(
                        title: context.i18n.push_notification_social_group_title,
                        selected: socialNotifications,
                        options: SocialNotificationOption.values,
                        onSelected: toggleSocialNotification,
                        enabled: hasNotificationsPermission,
                      ),
                      SelectableOptionsGroup(
                        title: context.i18n.push_notification_chat_group_title,
                        selected: chatNotifications,
                        options: ChatNotificationOption.values,
                        onSelected: toggleChatNotification,
                        enabled: hasNotificationsPermission,
                      ),
                      SelectableOptionsGroup(
                        title: context.i18n.push_notification_wallet_group_title,
                        selected: walletNotifications,
                        options: WalletNotificationOption.values,
                        onSelected: toggleWalletNotification,
                        enabled: hasNotificationsPermission,
                      ),
                      SelectableOptionsGroup(
                        title: context.i18n.push_notification_system_group_title,
                        selected: systemNotifications,
                        options: SystemNotificationOption.values,
                        onSelected: toggleSystemNotification,
                        enabled: hasNotificationsPermission,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DevicePermissionButton extends StatelessWidget {
  const _DevicePermissionButton({
    required this.hasPermission,
    required this.hasPermissionOnDeviceLevel,
    required this.onChangeAppLevelPermission,
  });

  final VoidCallback onChangeAppLevelPermission;
  final bool hasPermissionOnDeviceLevel;
  final bool hasPermission;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PermissionAwareWidget(
          permissionType: Permission.notifications,
          requestDialog: const PermissionRequestSheet(
            permission: Permission.notifications,
          ),
          onGranted: () {},
          builder: (BuildContext context, VoidCallback onPressed) {
            final onTap = hasPermissionOnDeviceLevel ? onChangeAppLevelPermission : onPressed;

            return ListItem(
              onTap: onTap,
              title: Text(
                context.i18n.push_notification_device_permission,
              ),
              leading: Button.icon(
                backgroundColor: context.theme.appColors.secondaryBackground,
                borderColor: context.theme.appColors.onTerararyFill,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0.s),
                ),
                size: 36.0.s,
                onPressed: onTap,
                icon: Assets.svg.iconProfileDevicepermission.icon(
                  color: context.theme.appColors.primaryAccent,
                ),
              ),
              trailing: hasPermission
                  ? Assets.svg.iconBlockCheckboxOn.icon()
                  : Assets.svg.iconBlockCheckboxOff.icon(),
            );
          },
        ),
      ],
    );
  }
}
