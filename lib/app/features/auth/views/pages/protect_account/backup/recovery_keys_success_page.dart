import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeysSuccessPage extends StatelessWidget {
  const RecoveryKeysSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: AuthScrollContainer(
        showBackButton: false,
        actions: [
          NavigationCloseButton(
            onPressed: () => WalletRoute().go(context),
          )
        ],
        title: 'Recovery keys',
        icon: Assets.images.icons.iconLoginRestorekey.icon(size: 36.0.s),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.0.s),
            child: Column(
              children: [
                SizedBox(height: 12.0.s),
                InfoCard(
                  iconAsset: Assets.images.icons.actionWalletSecureaccsuccess,
                  title: 'Successfully protected',
                  description:
                      'Your recovery keys have been securely backed up. Please keep them safe for future account recovery',
                ),
                SizedBox(height: 12.0.s),
              ],
            ),
          ),
          ScreenBottomOffset(
            margin: 36.0.s,
            child: ScreenSideOffset.large(
              child: Button(
                onPressed: () => SecureAccountOptionsRoute().replace(context),
                label: Text('Back to Security'),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ),
          // ScreenBottomOffset(margin: 36.0.s),
        ],
      ),
    );
  }
}
