import 'package:flutter/material.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/authenticator/model/authenticator_type.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/components/secure_account_option.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class SecureAccountOptionsPage extends StatelessWidget {
  const SecureAccountOptionsPage({super.key});

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
          SizedBox(height: 36.0.s),
          ScreenSideOffset.small(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.s),
                  child: InfoCard(
                    iconAsset: Assets.images.icons.actionWalletSecureaccount,
                    title: locale.protect_account_title_secure_account,
                    description: locale.protect_account_description_secure_account_2fa,
                  ),
                ),
                SizedBox(height: 32.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_backup,
                  icon: Assets.images.icons.iconProtectwalletIcloud.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => BackupOptionsRoute().push<void>(context),
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_email,
                  icon: Assets.images.icons.iconFieldEmail.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () {},
                  trailing: Assets.images.icons.iconDappCheck.icon(
                    color: context.theme.appColors.success,
                  ),
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_authenticator,
                  icon: Assets.images.icons.iconLoginAuthcode.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () => AuthenticatorSetupRoute(
                    step: AuthenticatorSteps.options,
                  ).push<void>(context),
                ),
                SizedBox(height: 12.0.s),
                SecureAccountOption(
                  title: locale.two_fa_option_phone,
                  icon: Assets.images.icons.iconFieldPhone.icon(
                    color: context.theme.appColors.primaryAccent,
                  ),
                  onTap: () {},
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
