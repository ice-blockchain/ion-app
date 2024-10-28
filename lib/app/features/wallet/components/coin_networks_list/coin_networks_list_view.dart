// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/components/coin_networks_list/coin_network_item.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';

class CoinNetworksListView extends ConsumerWidget {
  const CoinNetworksListView({
    required this.onItemTap,
    required this.coinId,
    required this.title,
    super.key,
  });

  final void Function(NetworkType networkType) onItemTap;
  final String coinId;
  final String title;

  static final List<NetworkType> networkTypeValues =
      NetworkType.values.where((type) => type != NetworkType.all).toList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 12.0.s,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return ScreenSideOffset.small(
              child: CoinNetworkItem(
                coinId: coinId,
                networkType: networkTypeValues[index],
                onTap: () => onItemTap(networkTypeValues[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}
