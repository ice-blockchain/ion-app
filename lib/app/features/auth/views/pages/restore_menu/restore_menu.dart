import 'package:flutter/material.dart';
import 'package:ice/app/components/card/rounded_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/auth_footer/auth_footer.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header.dart';
import 'package:ice/app/features/auth/views/components/auth_header/auth_header_icon.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class RestoreMenuPage extends StatelessWidget {
  const RestoreMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              AuthHeader(
                title: context.i18n.restore_identity_title,
                description: context.i18n.restore_identity_type_description,
                icon: AuthHeaderIcon(
                  icon: Assets.images.icons.iconLoginRestorekey.icon(size: 36.0.s),
                ),
                showBackButton: false,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 38.0.s),
                child: Column(
                  children: [
                    RoundedCard(
                      padding: EdgeInsets.all(16.0.s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Assets.images.identity.walletLoginCloud.icon(size: 48.0.s),
                          SizedBox(height: 8.0.s),
                          Text(
                            context.i18n.restore_identity_type_icloud_title,
                            textAlign: TextAlign.center,
                            style: context.theme.appTextThemes.body.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 4.0.s),
                          Text(
                            context.i18n.restore_identity_type_icloud_description,
                            textAlign: TextAlign.center,
                            style: context.theme.appTextThemes.caption3.copyWith(
                              color: context.theme.appColors.secondaryText,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0.s),
                    RoundedCard(
                      padding: EdgeInsets.all(16.0.s),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Assets.images.identity.walletLoginRecovery.icon(size: 48.0.s),
                          SizedBox(height: 8.0.s),
                          Text(
                            context.i18n.restore_identity_type_credentials_title,
                            textAlign: TextAlign.center,
                            style: context.theme.appTextThemes.body.copyWith(
                              color: context.theme.appColors.primaryText,
                            ),
                          ),
                          SizedBox(height: 4.0.s),
                          Text(
                            context.i18n.restore_identity_type_credentials_description,
                            textAlign: TextAlign.center,
                            style: context.theme.appTextThemes.caption3.copyWith(
                              color: context.theme.appColors.secondaryText,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const AuthFooter(),
              ScreenBottomOffset(),
            ],
          ),
        ),
      ),
    );
  }
}
