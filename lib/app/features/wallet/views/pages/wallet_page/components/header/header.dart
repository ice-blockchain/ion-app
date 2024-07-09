import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/components/wallet_switcher/wallet_switcher.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_button/navigation_button.dart';
import 'package:ice/generated/assets.gen.dart';

class Header extends HookConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenSideOffset.small(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const WalletSwitcher(),
          Row(
            children: <Widget>[
              NavigationButton(
                onPressed: () {},
                icon: Assets.images.icons.iconHeaderCopy.icon(
                  color: context.theme.appColors.primaryText,
                ),
              ),
              SizedBox(width: 12.0.s),
              NavigationButton(
                onPressed: () => ScanWalletRoute().push<void>(context),
                icon: Assets.images.icons.iconHeaderScan1.icon(
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
