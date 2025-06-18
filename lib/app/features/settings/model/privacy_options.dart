// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/settings/model/selectable_option.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/generated/assets.gen.dart';

enum WalletAddressPrivacyOption implements SelectableOption {
  public,
  private;

  static WalletAddressPrivacyOption fromWalletsMap(Map<String, dynamic>? wallets) {
    return wallets == null ? WalletAddressPrivacyOption.private : WalletAddressPrivacyOption.public;
  }

  @override
  String getLabel(BuildContext context) => switch (this) {
        WalletAddressPrivacyOption.public => context.i18n.privacy_option_wallet_public,
        WalletAddressPrivacyOption.private => context.i18n.privacy_option_wallet_private,
      };

  @override
  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      WalletAddressPrivacyOption.public => Assets.svgIconChannelType,
      WalletAddressPrivacyOption.private => Assets.svgIconPrivacyPrivate,
    };
    return IconAssetColored(icon, color: context.theme.appColors.primaryAccent);
  }
}

enum UserVisibilityPrivacyOption implements SelectableOption {
  everyone,
  followedPeople,
  friends;

  static UserVisibilityPrivacyOption fromWhoCanSetting(WhoCanSetting? setting) => switch (setting) {
        WhoCanSetting.everyone => UserVisibilityPrivacyOption.everyone,
        WhoCanSetting.follows => UserVisibilityPrivacyOption.followedPeople,
        WhoCanSetting.friends => UserVisibilityPrivacyOption.friends,
        null => UserVisibilityPrivacyOption.everyone,
      };

  @override
  String getLabel(BuildContext context) => switch (this) {
        UserVisibilityPrivacyOption.everyone =>
          context.i18n.privacy_option_user_visibility_for_everyone,
        UserVisibilityPrivacyOption.followedPeople =>
          context.i18n.privacy_option_user_visibility_for_followed_people,
        UserVisibilityPrivacyOption.friends =>
          context.i18n.privacy_option_user_visibility_for_friends,
      };

  @override
  Widget getIcon(BuildContext context) {
    final icon = switch (this) {
      UserVisibilityPrivacyOption.everyone => Assets.svgIconPostEveryone,
      UserVisibilityPrivacyOption.followedPeople => Assets.svgIconSearchFollow,
      UserVisibilityPrivacyOption.friends => Assets.svgIconSearchGroups,
    };

    return IconAssetColored(icon, color: context.theme.appColors.primaryAccent);
  }

  WhoCanSetting? toWhoCanSetting() => switch (this) {
        UserVisibilityPrivacyOption.everyone => null,
        UserVisibilityPrivacyOption.followedPeople => WhoCanSetting.follows,
        UserVisibilityPrivacyOption.friends => WhoCanSetting.friends,
      };
}
