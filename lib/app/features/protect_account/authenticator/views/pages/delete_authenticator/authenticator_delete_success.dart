// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class AuthenticatorDeleteSuccessPage extends StatelessWidget {
  const AuthenticatorDeleteSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              ),
            ],
          ),
          AuthHeader(
            topOffset: 34.0.s,
            title: locale.two_fa_option_authenticator,
            titleStyle: context.theme.appTextThemes.headline2,
            descriptionStyle: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.secondaryText,
            ),
            icon: AuthHeaderIcon(
              icon: Assets.svg.icon2faAuthsetup.icon(size: 36.0.s),
            ),
          ),
          const Spacer(),
          ScreenSideOffset.medium(
            child: InfoCard(
              iconAsset: Assets.svg.actionWalletGoogleauth,
              title: locale.common_congratulations,
              description: locale.authenticator_has_deleted,
            ),
          ),
          const Spacer(),
          ScreenSideOffset.large(
            child: Button(
              mainAxisSize: MainAxisSize.max,
              label: Text(locale.button_back_to_security),
              onPressed: () => SecureAccountOptionsRoute().replace(context),
            ),
          ),
          ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }
}
