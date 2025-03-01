// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/build_context.dart';
import 'package:ion/app/extensions/theme_data.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coins_by_filters_provider.c.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/coin_networks_list/coin_networks_list_view.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum SelectNetworkModalType {
  select,
  update,
}

class SelectNetworkModal extends ConsumerWidget {
  const SelectNetworkModal({
    required this.pubkey,
    required this.type,
    required this.coinSymbolGroup,
    required this.coinAbbreviation,
    required this.paymentType,
    super.key,
  });

  final String pubkey;
  final SelectNetworkModalType type;
  final String coinSymbolGroup;
  final String coinAbbreviation;
  final PaymentType paymentType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coinNetworks = switch (paymentType) {
      PaymentType.send => ref.watch(syncedCoinsBySymbolGroupProvider(coinSymbolGroup)),
      PaymentType.receive => ref.watch(
          coinsByFiltersProvider(
            symbol: coinAbbreviation,
            symbolGroup: coinSymbolGroup,
          ),
        ),
    };
    return SheetContent(
      body: CoinNetworksListView(
        coinNetworks: coinNetworks,
        onItemTap: (NetworkData network) {
          switch (type) {
            case SelectNetworkModalType.select:
              switch (paymentType) {
                case PaymentType.send:
                  SendCoinsFormRoute(
                    pubkey: pubkey,
                    networkId: network.id,
                    coinSymbolGroup: coinSymbolGroup,
                    coinAbbreviation: coinAbbreviation,
                  ).replace(context);
                case PaymentType.receive:
                  RequestCoinsFormRoute(
                    pubkey: pubkey,
                    networkId: network.id,
                    coinSymbolGroup: coinSymbolGroup,
                    coinAbbreviation: coinAbbreviation,
                  ).replace(context);
              }
            case SelectNetworkModalType.update:
              context.pop(network);
          }
        },
        title: context.i18n.wallet_choose_network,
      ),
      backgroundColor: context.theme.appColors.secondaryBackground,
    );
  }
}
