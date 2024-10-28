// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/components/wallet_switcher/wallet_switcher.dart';
import 'package:ion/app/router/components/navigation_button/navigation_button.dart';
import 'package:ion/generated/assets.gen.dart';

class WalletHeader extends ConsumerWidget {
  const WalletHeader({super.key});

  static double get height => 40.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.small(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const WalletSwitcher(),
          Row(
            children: [
              NavigationButton(
                onPressed: () {},
                icon: Assets.svg.iconFieldSearch.icon(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              SizedBox(width: 12.0.s),
              NavigationButton(
                onPressed: () {},
                icon: Assets.svg.iconHeaderMenu.icon(
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
