// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/hooks/use_check_wallet_address_available.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/components/info_card.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/components/receive_info_card.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/services/share/share.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareAddressView extends HookConsumerWidget {
  const ShareAddressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final network = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedNetwork),
    );
    final coin = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedCoin),
    );

    useCheckWalletAddressAvailable(
      ref,
      network: network,
      coinsGroup: coin,
      onAddressFound: (address) =>
          ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(address),
      onAddressMissing: () => AddressNotFoundReceiveRoute().replace(ref.context),
      keys: [network, coin],
    );

    final walletAddress = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.address),
    );

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: Text(context.i18n.wallet_share_address),
              actions: [
                NavigationCloseButton(
                  onPressed: Navigator.of(context, rootNavigator: true).pop,
                ),
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
                  leadingIcon: IconAssetColored(
                    Assets.svgIconButtonShare,
                    color: context.theme.appColors.secondaryBackground,
                  ),
                  label: Text(
                    context.i18n.button_share,
                  ),
                  disabled: walletAddress == null,
                  onPressed: () {
                    if (walletAddress != null) {
                      shareContent(walletAddress);
                    }
                  },
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
