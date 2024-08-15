import 'package:flutter/material.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/backup/components/backup_option.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class BackupOptionsPage extends StatelessWidget {
  const BackupOptionsPage({super.key});

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
          SizedBox(height: 32.0.s),
          ScreenSideOffset.small(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.s),
                  child: Column(
                    children: [
                      Text(
                        'Select backup',
                        textAlign: TextAlign.center,
                        style: context.theme.appTextThemes.headline2.copyWith(
                          color: context.theme.appColors.primaryText,
                        ),
                      ),
                      SizedBox(height: 8.0.s),
                      Text(
                        'Backups enable you to restore your data and wallet if something goes wrong',
                        textAlign: TextAlign.center,
                        style: context.theme.appTextThemes.body2.copyWith(
                          color: context.theme.appColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.0.s),
                BackupOption(
                  title: 'Backup with Google Drive',
                  subtitle: 'Safe and simple way to protect your account',
                  icon: Assets.images.identity.walletLoginCloud.icon(
                    size: 48.0.s,
                  ),
                  isOptionEnabled: true,
                  onTap: () {},
                ),
                SizedBox(height: 16.0.s),
                BackupOption(
                  title: 'Recovery keys',
                  subtitle: 'Write down and store your keys on paper for secure account recovery',
                  icon: Assets.images.identity.walletLoginRecovery.icon(
                    size: 48.0.s,
                  ),
                  onTap: () => BackupRecoveryKeysRoute().push<void>(context),
                ),
                ScreenBottomOffset(margin: 32.0.s),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
