import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/auth/views/pages/protect_account/backup/components/recovery_key_option.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeysSavePage extends StatelessWidget {
  const RecoveryKeysSavePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final locale = context.i18n;

    return SheetContent(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NavigationAppBar.modal(
              actions: [
                NavigationCloseButton(
                  onPressed: () => WalletRoute().go(context),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.0.s),
              child: AuthHeader(
                title: 'Recovery keys',
                description: 'Write down and store your keys on paper for secure account recovery',
                icon: AuthHeaderIcon(
                  icon: Assets.images.icons.iconLoginRestorekey.icon(
                    size: 36.0.s,
                  ),
                ),
              ),
            ),
            ScreenSideOffset.large(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RecoveryKeyOption(
                    title: 'Identity key name',
                    iconAsset: Assets.images.icons.iconIdentitykey,
                    subtitle: '838402-28385-432',
                  ),
                  SizedBox(height: 12.0.s),
                  RecoveryKeyOption(
                    title: 'Recovery Key ID',
                    iconAsset: Assets.images.icons.iconChannelPrivate,
                    subtitle: '08402934823044809485',
                  ),
                  SizedBox(height: 12.0.s),
                  RecoveryKeyOption(
                    title: 'Recovery code',
                    iconAsset: Assets.images.icons.iconCode4,
                    subtitle: '0405904949596000',
                  ),
                  SizedBox(height: 20.0.s),
                  RoundedCard.outlined(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0.s,
                      horizontal: 10.0.s,
                    ),
                    child: ListItem(
                      contentPadding: EdgeInsets.zero,
                      backgroundColor: context.theme.appColors.secondaryBackground,
                      borderRadius: BorderRadius.all(
                        Radius.circular(16.0.s),
                      ),
                      leading: Assets.images.icons.iconReport.icon(
                        size: 20.0.s,
                        color: context.theme.appColors.attentionRed,
                      ),
                      title: Text(
                        'Avoid storing keys on any device to prevent losing access to funds in case of a hack',
                        style: context.theme.appTextThemes.caption.copyWith(
                          color: context.theme.appColors.attentionRed,
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0.s),
                  Button(
                    mainAxisSize: MainAxisSize.max,
                    label: Text('Continue'),
                    onPressed: () => RecoveryKeysInputRoute().push<void>(context),
                  ),
                ],
              ),
            ),
            ScreenBottomOffset(margin: 36.0.s),
          ],
        ),
      ),
    );
  }
}
