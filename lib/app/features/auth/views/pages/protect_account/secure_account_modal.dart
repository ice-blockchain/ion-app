import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SecureAccountModal extends StatelessWidget {
  const SecureAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(
              'Security',
            ),
            actions: [NavigationCloseButton()],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.s),
            child: Column(
              children: [
                InfoCard(
                  iconAsset: Assets.images.identity.actionWalletIdkey,
                  title: 'Secure your account',
                  description:
                      'Securing your account ensures you never lose access to your data and funds',
                ),
                SizedBox(height: 12.0.s),
                SizedBox(
                  height: 30.0.s,
                ),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  leadingIcon: Assets.images.icons.iconWalletProtectVar1.icon(
                    color: Colors.transparent,
                  ),
                  label: Text(
                    'Protect account',
                  ),
                  onPressed: () {},
                ),
                ScreenBottomOffset(),
                ScreenBottomOffset(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
