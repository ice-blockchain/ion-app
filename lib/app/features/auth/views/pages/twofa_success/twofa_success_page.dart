import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/card/info_card.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class TwoFaSuccessPage extends StatelessWidget {
  const TwoFaSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final onLogin = () => GetStartedRoute().go(context);

    return SheetContent(
      body: AuthScrollContainer(
        showBackButton: false,
        actions: [
          NavigationCloseButton(
            onPressed: onLogin,
          )
        ],
        title: context.i18n.two_fa_title,
        description: context.i18n.two_fa_desc,
        icon: Assets.images.icons.iconWalletProtect.icon(size: 36.0.s),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.0.s),
            child: Column(
              children: [
                SizedBox(height: 12.0.s),
                InfoCard(
                  iconAsset: Assets.images.icons.actionWalletSuccess2Fa,
                  title: context.i18n.common_congratulations,
                  description: context.i18n.two_fa_success_desc,
                ),
                SizedBox(height: 12.0.s),
              ],
            ),
          ),
          ScreenBottomOffset(
            margin: 36.0.s,
            child: ScreenSideOffset.large(
              child: Button(
                onPressed: onLogin,
                label: Text(context.i18n.button_login),
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
