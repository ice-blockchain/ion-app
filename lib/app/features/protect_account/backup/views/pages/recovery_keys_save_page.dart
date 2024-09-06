import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_header_icon.dart';
import 'package:ice/app/features/protect_account/backup/views/components/recovery_key_option.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RecoveryKeysSavePage extends StatelessWidget {
  const RecoveryKeysSavePage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.i18n;

    return SheetContent(
      body: Column(
        children: [
          NavigationAppBar.modal(
            actions: [
              NavigationCloseButton(
                onPressed: () => WalletRoute().go(context),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: 16.0.s,
            ),
            child: AuthHeader(
              topOffset: 0.0.s,
              title: locale.backup_option_with_recovery_keys_title,
              description: locale.backup_option_with_recovery_keys_description,
              titleStyle: context.theme.appTextThemes.headline2,
              descriptionStyle: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.secondaryText,
              ),
              icon: AuthHeaderIcon(
                icon: Assets.images.icons.iconLoginRestorekey.icon(
                  size: 36.0.s,
                ),
              ),
            ),
          ),
          ScreenSideOffset.large(
            child: Column(
              children: [
                RecoveryKeyOption(
                  title: locale.common_identity_key_name,
                  iconAsset: Assets.images.icons.iconIdentitykey,
                  subtitle: '838402-28385-432',
                ),
                SizedBox(height: 12.0.s),
                RecoveryKeyOption(
                  title: locale.restore_identity_creds_recovery_key,
                  iconAsset: Assets.images.icons.iconChannelPrivate,
                  subtitle: '08402934823044809485',
                ),
                SizedBox(height: 12.0.s),
                RecoveryKeyOption(
                  title: locale.restore_identity_creds_recovery_code,
                  iconAsset: Assets.images.icons.iconCode4,
                  subtitle: '0405904949596000',
                ),
                SizedBox(height: 20.0.s),
                RoundedCard.outlined(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.s),
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
                      locale.warning_avoid_storing_keys,
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
                  label: Text(locale.button_continue),
                  onPressed: () => RecoveryKeysInputRoute().push<void>(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
