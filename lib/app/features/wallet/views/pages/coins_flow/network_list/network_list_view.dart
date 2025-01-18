// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/network_list/network_item.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum NetworkListViewType { send, receive }

class NetworkListView extends ConsumerWidget {
  const NetworkListView({
    this.type = NetworkListViewType.send,
    this.onSelectReturnType = false,
    super.key,
  });

  final bool onSelectReturnType;
  final NetworkListViewType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const networks = NetworkType.values;
    final coinData = switch (type) {
      NetworkListViewType.send => ref.watch(sendAssetFormControllerProvider()).selectedCoin!,
      NetworkListViewType.receive => ref.watch(receiveCoinsFormControllerProvider).selectedCoin,
    };

    // TODO: (1) null case is not implemented
    if (coinData == null) {
      return const SizedBox.shrink();
    }

    void onTap(NetworkType network) {
      if (onSelectReturnType) {
        Navigator.of(context).pop(network);
        return;
      }

      switch (type) {
        case NetworkListViewType.send:
          ref.read(sendAssetFormControllerProvider().notifier).setNetwork(network);
          CoinsSendFormRoute().push<void>(context);
        case NetworkListViewType.receive:
          ref.read(receiveCoinsFormControllerProvider.notifier).setNetwork(network);
          ShareAddressRoute().push<void>(context);
      }
    }

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: Text(context.i18n.wallet_choose_network),
              actions: const [
                NavigationCloseButton(),
              ],
            ),
          ),
          ScreenBottomOffset(
            margin: 32.0.s,
            child: ScreenSideOffset.small(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: networks.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.0.s),
                itemBuilder: (BuildContext context, int index) {
                  final network = networks[index];
                  return NetworkItem(
                    coinInWallet: coinData,
                    networkType: networks[index],
                    onTap: () => onTap(network),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
