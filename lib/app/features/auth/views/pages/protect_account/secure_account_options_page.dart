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
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text('Security'),
            actions: [NavigationCloseButton()],
          ),
          SizedBox(height: 40.0.s),
          ScreenSideOffset.small(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.s),
                  child: InfoCard(
                    iconAsset: Assets.images.identity.actionWalletIdkey,
                    title: 'Secure your account',
                    description:
                        'To secure your account, back it up and enable at least one 2FA option',
                  ),
                ),
                SizedBox(height: 32.0.s),
                Column(
                  children: [
                    ListItem(
                      title: Text('Backup'),
                      backgroundColor: context.theme.appColors.tertararyBackground,
                      leading: Button.icon(
                        backgroundColor: context.theme.appColors.secondaryBackground,
                        borderColor: context.theme.appColors.onTerararyFill,
                        borderRadius: BorderRadius.all(Radius.circular(16.0.s)),
                        type: ButtonType.menuInactive,
                        size: 36.0.s,
                        onPressed: () {},
                        icon: Assets.images.icons.iconHeaderCopy.icon(
                          color: context.theme.appColors.primaryAccent,
                        ),
                      ),
                      trailing: Assets.images.icons.iconArrowRight.icon(),
                      onTap: () {},
                    ),
                    SizedBox(height: 12.0.s),
                    ListItem(
                      title: Text('Email'),
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
                      title: Text('Authenticator'),
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
                      title: Text('Phone'),
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
