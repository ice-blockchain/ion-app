// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/data/models/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/data/models/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/utils/num.dart';

part 'coin_network_item.dart';

class CoinNetworksListView extends ConsumerWidget {
  const CoinNetworksListView({
    required this.onItemTap,
    required this.coinNetworks,
    required this.title,
    super.key,
  });

  final void Function(NetworkData network) onItemTap;
  final AsyncValue<List<CoinInWalletData>> coinNetworks;
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: NavigationAppBar.screen(
            title: Text(title),
            actions: const [
              NavigationCloseButton(),
            ],
          ),
        ),
        Flexible(
          child: coinNetworks.maybeMap(
            data: (data) {
              final coins = data.value;
              return ListView.separated(
                shrinkWrap: true,
                itemCount: coins.length,
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12.0.s),
                itemBuilder: (BuildContext context, int index) {
                  final coin = coins[index];
                  return ScreenSideOffset.small(
                    child: _CoinNetworkItem(
                      coinInWallet: coin,
                      onTap: () => onItemTap(coin.coin.network),
                    ),
                  );
                },
              );
            },
            orElse: () => ListItemsLoadingState(
              listItemsLoadingStateType: ListItemsLoadingStateType.listView,
              itemHeight: 60.0.s,
            ),
          ),
        ),
      ],
    );
  }
}
