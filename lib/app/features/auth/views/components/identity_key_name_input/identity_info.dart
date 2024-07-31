import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/generated/assets.gen.dart';

class IdentityInfo extends StatelessWidget {
  const IdentityInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
          title: Text(context.i18n.identity_key_name_title),
          actions: [NavigationCloseButton()],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.s),
          child: Column(
            children: [
              InfoCard(
                iconAsset: Assets.images.identity.actionWalletIdkey,
                title: context.i18n.common_identity_key_name,
                description: context.i18n.identity_key_name_description,
              ),
              SizedBox(height: 12.0.s),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: context.i18n.identity_key_name_usage),
                    const TextSpan(text: ' '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Assets.images.icons.iconLoginIdentity.icon(size: 20.0.s),
                    ),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: context.i18n.auth_identity_io,
                      style: context.theme.appTextThemes.caption.copyWith(
                        color: context.theme.appColors.primaryAccent,
                      ),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
              ),
              ScreenBottomOffset(),
            ],
          ),
        ),
      ],
    );
  }
}
