import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/generated/assets.gen.dart';

class TwoFaTryAgainPage extends StatelessWidget {
  const TwoFaTryAgainPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationAppBar.modal(
          showBackButton: false,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.0.s),
          child: Column(
            children: [
              InfoCard(
                iconAsset: Assets.images.icons.actionWalletKeyserror,
                title: context.i18n.two_fa_failure_title,
                description: context.i18n.two_fa_failure_desc,
              ),
            ],
          ),
        ),
        SizedBox(height: 30.0.s),
        ScreenSideOffset.small(
          child: Button(
            onPressed: () => rootNavigatorKey.currentState?.pop(),
            label: Text(context.i18n.button_try_again),
            mainAxisSize: MainAxisSize.max,
          ),
        ),
        ScreenBottomOffset(),
      ],
    );
  }
}
