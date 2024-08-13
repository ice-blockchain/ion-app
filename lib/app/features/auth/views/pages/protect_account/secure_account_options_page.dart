import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
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
          SizedBox(height: 40.0.s),
          ScreenSideOffset.small(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.s),
                  child: InfoCard(
                    iconAsset: Assets.images.identity.actionWalletIdkey,
                    title: locale.protect_account_title_secure_account,
                    description: locale.protect_account_description_secure_account_2fa,
                  ),
                ),
                SizedBox(height: 32.0.s),
                Column(
                  children: [
                    ListItem(
                      title: Text(locale.two_fa_option_backup),
                      backgroundColor: context.theme.appColors.tertararyBackground,
                      leading: Button.icon(
                        backgroundColor: context.theme.appColors.secondaryBackground,
                        borderColor: context.theme.appColors.onTerararyFill,
                        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
                        type: ButtonType.menuInactive,
                        size: 36.0.s,
                        onPressed: () {},
                        icon: Assets.images.icons.iconProtectwalletIcloud.icon(
                          color: context.theme.appColors.primaryAccent,
                        ),
                      ),
                      trailing: Assets.images.icons.iconArrowRight.icon(),
                      onTap: () {},
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem(
                      title: Text(locale.two_fa_option_email),
                      backgroundColor: context.theme.appColors.tertararyBackground,
                      leading: Button.icon(
                        backgroundColor: context.theme.appColors.secondaryBackground,
                        borderColor: context.theme.appColors.onTerararyFill,
                        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
                        type: ButtonType.menuInactive,
                        size: 36.0.s,
                        onPressed: () {},
                        icon: Assets.images.icons.iconFieldEmail.icon(
                          color: context.theme.appColors.primaryAccent,
                        ),
                      ),
                      trailing: Assets.images.icons.iconDappCheck.icon(
                        color: context.theme.appColors.success,
                      ),
                      onTap: () {},
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem(
                      title: Text(locale.two_fa_option_authenticator),
                      backgroundColor: context.theme.appColors.tertararyBackground,
                      leading: Button.icon(
                        backgroundColor: context.theme.appColors.secondaryBackground,
                        borderColor: context.theme.appColors.onTerararyFill,
                        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
                        type: ButtonType.menuInactive,
                        size: 36.0.s,
                        onPressed: () {},
                        icon: Assets.images.icons.iconLoginAuthcode.icon(
                          color: context.theme.appColors.primaryAccent,
                        ),
                      ),
                      trailing: Assets.images.icons.iconArrowRight.icon(),
                      onTap: () {
                        SecureAccountErrorRoute().push<void>(context);
                      },
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem(
                      title: Text(locale.two_fa_option_phone),
                      backgroundColor: context.theme.appColors.tertararyBackground,
                      leading: Button.icon(
                        backgroundColor: context.theme.appColors.secondaryBackground,
                        borderColor: context.theme.appColors.onTerararyFill,
                        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
                        type: ButtonType.menuInactive,
                        size: 36.0.s,
                        onPressed: () {},
                        icon: Assets.images.icons.iconFieldPhone.icon(
                          color: context.theme.appColors.primaryAccent,
                        ),
                      ),
                      trailing: Assets.images.icons.iconArrowRight.icon(),
                      onTap: () {},
                    ),
                  ],
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
