// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separated_column.dart';
import 'package:ion/app/constants/links.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/core/providers/app_info_provider.dart';
import 'package:ion/app/features/user/pages/switch_account_modal/components/action_button/action_button.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/services/browser/browser.dart';
import 'package:ion/generated/assets.gen.dart';

class SettingsModal extends ConsumerWidget {
  const SettingsModal({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconColor = context.theme.appColors.primaryAccent;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.profile_settings_title),
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
                ActionButton(
                  icon: Assets.svg.iconProfileUser.icon(
                    color: iconColor,
                  ),
                  label: context.i18n.profile_settings_profile,
                  onTap: () {
                    ProfileSettingsRoute(pubkey: pubkey).push<void>(context);
                  },
                ),
                ActionButton(
                  icon: Assets.svg.linearSecurityShielduser.icon(
                    color: iconColor,
                  ),
                  label: context.i18n.profile_settings_security,
                  onTap: () {
                    SecureAccountOptionsRoute(pubkey: pubkey).push<void>(context);
                  },
                ),
                ActionButton(
                  icon: Assets.svg.iconProfilePrivacy.icon(
                    color: iconColor,
                  ),
                  label: context.i18n.profile_settings_privacy,
                  onTap: () {},
                ),
                ActionButton(
                  icon: Assets.svg.iconHomeNotification.icon(
                    color: iconColor,
                  ),
                  label: context.i18n.profile_settings_push_notifications,
                  onTap: () {},
                ),
                ActionButton(
                  icon: Assets.svg.iconProfilePrivacypolicy.icon(
                    color: iconColor,
                  ),
                  label: context.i18n.profile_settings_privacy_policy,
                  onTap: () => openUrlInAppBrowser(Links.privacy),
                ),
                ActionButton(
                  icon: Assets.svg.iconProfileTerms.icon(
                    color: iconColor,
                  ),
                  label: context.i18n.profile_settings_terms_conditions,
                  onTap: () => openUrlInAppBrowser(Links.terms),
                ),
                ActionButton(
                  icon: Assets.svg.iconMenuLogout.icon(
                    color: context.theme.appColors.attentionRed,
                  ),
                  label: context.i18n.profile_settings_logout,
                  onTap: () {
                    ConfirmLogoutRoute(pubkey: pubkey).push<void>(context);
                  },
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
      appInfo == null ? '' : context.i18n.profile_settings_app_version(appInfo.version),
      textAlign: TextAlign.center,
      style: context.theme.appTextThemes.caption3,
    );
  }
}
