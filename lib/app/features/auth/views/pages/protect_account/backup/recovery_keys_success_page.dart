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
    final locale = context.i18n;

    return SheetContent(
      body: AuthScrollContainer(
        showBackButton: false,
        titleStyle: context.theme.appTextThemes.headline2,
        descriptionStyle: context.theme.appTextThemes.body2.copyWith(
          color: context.theme.appColors.secondaryText,
        ),
        actions: [
          NavigationCloseButton(
            onPressed: () => WalletRoute().go(context),
          )
        ],
        title: locale.backup_option_with_recovery_keys_title,
        icon: Assets.images.icons.iconLoginRestorekey.icon(size: 36.0.s),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.0.s),
            child: Column(
              children: [
                SizedBox(height: 12.0.s),
                InfoCard(
                  iconAsset: Assets.images.icons.actionWalletSecureaccsuccess,
                  title: locale.recovery_keys_successfully_protected_title,
                  description: locale.recovery_keys_successfully_protected_description,
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
                label: Text(locale.button_back_to_security),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
