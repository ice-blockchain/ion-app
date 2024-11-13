// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SecureAccountModal extends StatelessWidget {
  const SecureAccountModal({required this.pubkey, super.key});

  final String pubkey;

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(locale.protect_account_header_security),
            actions: [
              NavigationCloseButton(
                onPressed: () => ProfileRoute(pubkey: pubkey).go(context),
              ),
            ],
          ),
          SizedBox(height: 16.0.s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.s),
            child: Column(
              children: [
                InfoCard(
                  iconAsset: Assets.svg.actionWalletSecureaccount,
                  title: locale.protect_account_title_secure_account,
                  description: locale.protect_account_description_secure_account,
                ),
                SizedBox(height: 32.0.s),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  leadingIcon: Assets.svg.iconWalletProtectAccount.icon(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
                  label: Text(locale.protect_account_button),
                  onPressed: () => SecureAccountOptionsRoute(pubkey: pubkey).push<void>(context),
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
