// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SecureAccountErrorAlert extends StatelessWidget {
  const SecureAccountErrorAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(locale.protect_account_header_security),
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              ),
            ],
          ),
          SizedBox(height: 16.0.s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.s),
            child: Column(
              children: [
                InfoCard(
                  iconAsset: Assets.svg.actionWalletAutherror,
                  title: locale.two_fa_failure_authenticator_title,
                  description: locale.two_fa_failure_authenticator_description,
                ),
                SizedBox(height: 32.0.s),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text(locale.button_back),
                  onPressed: () => context.pop(),
                ),
                ScreenBottomOffset(margin: 36.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
