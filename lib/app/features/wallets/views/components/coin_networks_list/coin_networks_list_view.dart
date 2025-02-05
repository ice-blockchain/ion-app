// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/providers/wallet_user_preferences/user_preferences_selectors.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/utils/num.dart';

part 'coin_network_item.dart';

class CoinNetworksListView extends StatelessWidget {
  const CoinNetworksListView({
    required this.onItemTap,
    required this.coinAbbreviation,
    required this.title,
    super.key,
  });

  final void Function(Network network) onItemTap;
  final String coinAbbreviation;
  final String title;

  static const List<Network> networkTypeValues = Network.values;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: NavigationAppBar.screen(
            showBackButton: false,
            title: Text(title),
            actions: [
              NavigationCloseButton(
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: networkTypeValues.length,
          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12.0.s),
          itemBuilder: (BuildContext context, int index) {
            return ScreenSideOffset.small(
              child: _CoinNetworkItem(
                coinAbbreviation: coinAbbreviation,
                network: networkTypeValues[index],
                onTap: () => onItemTap(networkTypeValues[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}
