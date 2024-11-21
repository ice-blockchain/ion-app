// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/constants/links.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.dart';
import 'package:ion/app/features/core/providers/app_info_provider.dart';
import 'package:ion/app/features/settings/model/settings_action.dart';
import 'package:ion/app/features/user/pages/switch_account_modal/components/action_button/action_button.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/services/browser/browser.dart';

class SettingsModal extends ConsumerWidget {
  const SettingsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pubkey = ref.watch(currentPubkeySelectorProvider) ?? '';

    VoidCallback getOnPressed(SettingsAction option) {
      return switch (option) {
        SettingsAction.profile => () => ProfileSettingsRoute().push<void>(context),
        SettingsAction.security => () => SecureAccountOptionsRoute().push<void>(context),
        SettingsAction.privacy => () => PrivacySettingsRoute().push<void>(context),
        SettingsAction.pushNotifications => () =>
            PushNotificationsSettingsRoute().push<void>(context),
        SettingsAction.privacyPolicy => () => openUrlInAppBrowser(Links.privacy),
        SettingsAction.termsConditions => () => openUrlInAppBrowser(Links.terms),
        SettingsAction.logout => () => ConfirmLogoutRoute(pubkey: pubkey).push<void>(context),
      };
    }

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.common_profile),
            actions: [
              NavigationCloseButton(
                onPressed: context.pop,
              ),
            ],
          ),
          ScreenSideOffset.small(
            child: SeparatedColumn(
              separator: SizedBox(height: 9.0.s),
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final option in SettingsAction.values)
                  ActionButton(
                    icon: option.getIcon(context),
                    label: option.getLabel(context),
                    onTap: getOnPressed(option),
                  ),
                const _AppInfoWidget(),
              ],
            ),
          ),
          ScreenBottomOffset(margin: 32.0.s),
        ],
      ),
    );
  }
}

class _AppInfoWidget extends ConsumerWidget {
  const _AppInfoWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = ref.watch(appInfoProvider).valueOrNull;
    return Text(
      appInfo == null
          ? ''
          : context.i18n.settings_app_version('${appInfo.version} (${appInfo.buildNumber})'),
      textAlign: TextAlign.center,
      style: context.theme.appTextThemes.caption3,
    );
  }
}
