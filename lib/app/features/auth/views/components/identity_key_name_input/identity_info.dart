import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/components/identity_link/identity_link.dart';
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
          actions: [NavigationCloseButton(onPressed: () => context.pop())],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.s),
          child: Column(
            children: [
              InfoCard(
                iconAsset: Assets.svg.actionWalletIdKey,
                title: context.i18n.common_identity_key_name,
                description: context.i18n.identity_key_name_description,
              ),
              SizedBox(height: 12.0.s),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: context.i18n.identity_key_name_usage),
                    WidgetSpan(child: SizedBox(width: 6.0.s)),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: IdentityLink(),
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
