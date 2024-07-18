import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/info_card.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/components/receive_info_card.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';
import 'package:ice/generated/assets.gen.dart';

class ShareAddressView extends IcePage {
  const ShareAddressView({super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: context.i18n.wallet_share_address,
              actions: const [
                NavigationCloseButton(),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.s),
            child: Column(
              children: [
                const ReceiveInfoCard(),
                SizedBox(
                  height: 16.0.s,
                ),
                const InfoCard(),
                SizedBox(
                  height: 16.0.s,
                ),
                Button.compact(
                  mainAxisSize: MainAxisSize.max,
                  minimumSize: Size(56.0.s, 56.0.s),
                  leadingIcon: Assets.images.icons.iconButtonSend.icon(),
                  label: Text(
                    context.i18n.wallet_share,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          ScreenBottomOffset(),
        ],
      ),
    );
  }
}
