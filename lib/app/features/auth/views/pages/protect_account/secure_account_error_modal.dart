import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SecureAccountErrorModal extends StatelessWidget {
  const SecureAccountErrorModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text('Security'),
            actions: [
              NavigationCloseButton(
                onPressed: () => FeedMainModalRoute().replace(context),
              ),
            ],
          ),
          SizedBox(height: 32.0.s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.s),
            child: Column(
              children: [
                InfoCard(
                  iconAsset: Assets.images.icons.actionWalletAutherror,
                  title: 'Authenticator not available',
                  description:
                      'To set up an Authenticator app, please first link an email address or phone number to your account',
                ),
                SizedBox(height: 32.0.s),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text('Back'),
                  onPressed: () {},
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
