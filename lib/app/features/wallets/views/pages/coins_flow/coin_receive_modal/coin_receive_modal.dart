// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_receive_modal/components/coin_address_tile/coin_address_tile.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class CoinReceiveModal extends HookConsumerWidget {
  const CoinReceiveModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receiveCoinState = ref.watch(receiveCoinsFormControllerProvider);

    final updateNetwork = useCallback(
      (Network? network) {
        if (network != null) {
          ref.read(receiveCoinsFormControllerProvider.notifier).setNetwork(network);
        }
      },
      [],
    );

    useOnInit(
      () => updateNetwork(receiveCoinState.selectedNetwork),
    );

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NavigationAppBar.modal(
            title: Text(context.i18n.wallet_receive),
            actions: [
              NavigationCloseButton(
                onPressed: Navigator.of(context, rootNavigator: true).pop,
              ),
            ],
            showBackButton: false,
          ),
          // TODO: (1) check nullability here
          if (receiveCoinState.selectedCoin != null)
            ScreenSideOffset.small(
              child: CoinAddressTile(
                // TODO: (1) check coin data
                coinData: receiveCoinState.selectedCoin!.coins.first.coin,
              ),
            ),
          SizedBox(
            height: 15.0.s,
          ),
          // TODO: (1) Check nullability
          if (receiveCoinState.selectedNetwork case final Network network)
            ScreenSideOffset.small(
              child: ListItem(
                title: Text(context.i18n.wallet_network),
                subtitle: Text(network.name),
                switchTitleStyles: true,
                leading: network.svgIconAsset.icon(size: 36.0.s),
                trailing: Text(
                  context.i18n.wallet_change,
                  style: context.theme.appTextThemes.caption.copyWith(
                    color: context.theme.appColors.primaryAccent,
                  ),
                ),
                onTap: () async {
                  final result = await ChangeNetworkShareWalletRoute().push<Network?>(context);
                  if (result != null) updateNetwork(result);
                },
              ),
            ),
          ScreenBottomOffset(margin: 20.0.s),
        ],
      ),
    );
  }
}
