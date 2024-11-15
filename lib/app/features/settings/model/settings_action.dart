// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

enum SettingsAction {
  profile,
  security,
  privacy,
  pushNotifications,
  privacyPolicy,
  termsConditions,
  logout;

  String getLabel(BuildContext context) => switch (this) {
        SettingsAction.profile => context.i18n.common_profile,
        SettingsAction.security => context.i18n.settings_security,
        SettingsAction.privacy => context.i18n.settings_privacy,
        SettingsAction.pushNotifications => context.i18n.settings_push_notifications,
        SettingsAction.privacyPolicy => context.i18n.settings_privacy_policy,
        SettingsAction.termsConditions => context.i18n.settings_terms_conditions,
        SettingsAction.logout => context.i18n.settings_logout,
      };

  Color getIconColor(BuildContext context) => switch (this) {
        SettingsAction.logout => context.theme.appColors.attentionRed,
        _ => context.theme.appColors.primaryAccent,
      };

  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      SettingsAction.profile => Assets.svg.iconProfileUser,
      SettingsAction.security => Assets.svg.linearSecurityShielduser,
      SettingsAction.privacy => Assets.svg.iconProfilePrivacy,
      SettingsAction.pushNotifications => Assets.svg.iconHomeNotification,
      SettingsAction.privacyPolicy => Assets.svg.iconProfilePrivacypolicy,
      SettingsAction.termsConditions => Assets.svg.iconProfileTerms,
      SettingsAction.logout => Assets.svg.iconMenuLogout,
    };

    return icon.icon(color: getIconColor(context));
  }
}
