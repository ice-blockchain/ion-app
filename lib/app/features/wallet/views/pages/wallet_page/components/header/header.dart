// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/components/wallet_switcher/wallet_switcher.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_button/navigation_button.dart';
import 'package:ion/generated/assets.gen.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const WalletSwitcher(),
          Row(
            children: [
              NavigationButton(
                onPressed: () {},
                icon: Assets.svg.iconHeaderCopy.icon(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              SizedBox(width: 12.0.s),
              NavigationButton(
                onPressed: () => ScanWalletRoute().push<void>(context),
                icon: Assets.svg.iconHeaderScan1.icon(
                  color: context.theme.appColors.primaryText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
