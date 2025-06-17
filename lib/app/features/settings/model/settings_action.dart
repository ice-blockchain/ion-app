// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum SettingsAction {
  account,
  security,
  privacy,
  pushNotifications,
  privacyPolicy,
  termsConditions,
  leaveFeedback,
  logout;

  String getLabel(BuildContext context) => switch (this) {
        SettingsAction.account => context.i18n.common_account,
        SettingsAction.security => context.i18n.settings_security,
        SettingsAction.privacy => context.i18n.settings_privacy,
        SettingsAction.pushNotifications => context.i18n.settings_push_notifications,
        SettingsAction.privacyPolicy => context.i18n.settings_privacy_policy,
        SettingsAction.termsConditions => context.i18n.settings_terms_conditions,
        SettingsAction.leaveFeedback => context.i18n.settings_leave_feedback,
        SettingsAction.logout => context.i18n.settings_logout,
      };

  Color getIconColor(BuildContext context) => switch (this) {
        SettingsAction.logout => context.theme.appColors.attentionRed,
        _ => context.theme.appColors.primaryAccent,
      };

  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      SettingsAction.account => Assets.svgIconProfileUser,
      SettingsAction.security => Assets.svglinearSecurityShielduser,
      SettingsAction.privacy => Assets.svgIconProfilePrivacy,
      SettingsAction.pushNotifications => Assets.svgIconHomeNotification,
      SettingsAction.privacyPolicy => Assets.svgIconProfilePrivacypolicy,
      SettingsAction.termsConditions => Assets.svgIconProfileTerms,
      SettingsAction.leaveFeedback => Assets.svgIconProfileFeedback,
      SettingsAction.logout => Assets.svgIconMenuLogout,
    };

    return icon.icon(color: getIconColor(context));
  }
}
