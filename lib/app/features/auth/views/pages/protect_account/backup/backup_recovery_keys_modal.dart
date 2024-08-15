import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class BackupRecoveryKeysModal extends StatelessWidget {
  const BackupRecoveryKeysModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0.s),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.s),
            child: Column(
              children: [
                InfoCard(
                  iconAsset: Assets.images.icons.actionWalletLock,
                  title: 'Secure your recovery keys',
                  description:
                      'Please complete this process in a private place to ensure your account\'s safety',
                ),
                SizedBox(height: 20.0.s),
                Button(
                  mainAxisSize: MainAxisSize.max,
                  label: Text('Let\'s start'),
                  trailingIcon: Assets.images.icons.iconButtonNext.icon(
                    color: context.theme.appColors.onPrimaryAccent,
                  ),
                  onPressed: () => RecoveryKeysSaveRoute().push<void>(context),
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
