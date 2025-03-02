// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/model/coin_data.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coins_by_filters_provider.c.dart';
import 'package:ion/app/features/wallets/providers/mock_data/mock_data.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/network_list/network_item.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
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
    final coinsGroup = switch (type) {
      NetworkListViewType.send =>
        ref.watch(sendAssetFormControllerProvider()).assetData.as<CoinAssetData>()!.coinsGroup,
      NetworkListViewType.receive => ref.watch(receiveCoinsFormControllerProvider).selectedCoin!,
    };

    final coinsState = switch (type) {
      NetworkListViewType.send => ref.watch(
          syncedCoinsBySymbolGroupProvider(coinsGroup.symbolGroup),
        ),
      NetworkListViewType.receive => ref.watch(
          coinsByFiltersProvider(
            symbol: coinsGroup.abbreviation,
            symbolGroup: coinsGroup.symbolGroup,
          ),
        ),
    };

    void onTap(NetworkData network) {
      if (onSelectReturnType) {
        Navigator.of(context).pop(network);
        return;
      }

      switch (type) {
        case NetworkListViewType.send:
          ref.read(sendAssetFormControllerProvider().notifier)
            ..setNetwork(network)
            ..setReceiverAddress('');
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
          Flexible(
            child: ScreenBottomOffset(
              margin: 32.0.s,
              child: ScreenSideOffset.small(
                child: coinsState.maybeMap(
                  data: (data) => _NetworksList(
                    itemCount: data.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      final coin = data.value[index];
                      return NetworkItem(
                        coinInWallet: coin,
                        network: coin.coin.network,
                        onTap: () => onTap(coin.coin.network),
                      );
                    },
                  ),
                  orElse: () => const _LoadingState(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: _NetworksList(
        itemCount: 3,
        itemBuilder: (_, __) {
          return NetworkItem(
            coinInWallet: const CoinInWalletData(
              coin: CoinData(
                id: '',
                contractAddress: '',
                decimals: 1,
                iconUrl: '',
                name: '',
                network: mockedNetwork,
                priceUSD: 1,
                abbreviation: '',
                symbolGroup: '',
                syncFrequency: Duration.zero,
              ),
            ),
            network: mockedNetwork,
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _NetworksList extends StatelessWidget {
  const _NetworksList({
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: 12.0.s),
      itemBuilder: itemBuilder,
    );
  }
}
