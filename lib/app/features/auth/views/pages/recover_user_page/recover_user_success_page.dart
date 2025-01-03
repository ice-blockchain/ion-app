// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/card/info_card.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/asset_gen_image.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/auth/views/components/auth_scrolled_body/auth_scrolled_body.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class RecoverUserSuccessPage extends StatelessWidget {
  const RecoverUserSuccessPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void onLogin() => GetStartedRoute().go(context);

    return SheetContent(
      body: AuthScrollContainer(
        showBackButton: false,
        actions: [
          NavigationCloseButton(onPressed: onLogin),
        ],
        title: context.i18n.two_fa_title,
        description: context.i18n.two_fa_desc,
        icon: Assets.svg.iconWalletProtect.icon(size: 36.0.s),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 38.0.s),
            child: Column(
              children: [
                SizedBox(height: 12.0.s),
                InfoCard(
                  iconAsset: Assets.svg.actionWalletSuccess2Fa,
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
