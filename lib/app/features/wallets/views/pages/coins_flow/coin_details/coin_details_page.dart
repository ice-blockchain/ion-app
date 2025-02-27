// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/coins/coin_icon.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallets/model/coin_transaction_data.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/synced_coins_by_symbol_group_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/balance/balance.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_header.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_item.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_section_header.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/providers/coin_transactions_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/providers/hooks/use_transactions_by_date.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class CoinDetailsPage extends HookConsumerWidget {
  const CoinDetailsPage({required this.symbolGroup, super.key});

  final String symbolGroup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletView = ref.watch(currentWalletViewDataProvider).valueOrNull;
    final coinsGroup = walletView?.coinGroups.firstWhereOrNull((e) => e.symbolGroup == symbolGroup);

    final walletId = ref.watch(currentWalletViewIdProvider).valueOrNull;
    final scrollController = useScrollController();
    final coinTransactionsMap = useTransactionsByDate(context, ref);
    final isLoading = ref.watch(
      coinTransactionsNotifierProvider.select((data) => data.isLoading),
    );
    final networks = ref.watch(
      syncedCoinsBySymbolGroupProvider(symbolGroup).select(
        (value) => value.maybeWhen(
          data: (list) => list.map((e) => e.coin.network).toList(),
          orElse: () => const <NetworkData>[],
        ),
      ),
    );

    final activeNetwork = useState<NetworkData?>(null);

    useEffect(
      () {
        if (activeNetwork.value == null && networks.isNotEmpty) {
          activeNetwork.value = networks.first;
        }
        return null;
      },
      [networks],
    );

    useOnInit(
      () {
        if (walletId != null &&
            walletId.isNotEmpty &&
            coinsGroup != null &&
            activeNetwork.value != null) {
          ref.read(coinTransactionsNotifierProvider.notifier).fetch(
                walletId: walletId,
                coinId: coinsGroup.symbolGroup,
                network: activeNetwork.value!,
              );
        }
      },
      <Object?>[walletId, coinsGroup?.symbolGroup, activeNetwork.value],
    );

    // TODO: add proper loading and error handling
    if (coinsGroup == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CoinIconWidget(imageUrl: coinsGroup.iconUrl),
            SizedBox(width: 6.0.s),
            Text(coinsGroup.name),
          ],
        ),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const Delimiter(),
                if (activeNetwork.value != null)
                  Balance(
                    coinsGroup: coinsGroup,
                    network: activeNetwork.value!,
                  ),
                const Delimiter(),
              ],
            ),
          ),
          if (activeNetwork.value != null)
            SliverToBoxAdapter(
              child: TransactionListHeader(
                networks: networks,
                selectedNetwork: activeNetwork.value!,
                onNetworkTypeSelect: (NetworkData newNetwork) => activeNetwork.value = newNetwork,
              ),
            ),
          if (coinTransactionsMap.isEmpty && !isLoading) const EmptyState(),
          if (isLoading)
            ListItemsLoadingState(
              itemsCount: 7,
              separatorHeight: 12.0.s,
              listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
            ),
          if (coinTransactionsMap.isNotEmpty && !isLoading)
            for (final MapEntry<String, List<CoinTransactionData>>(
                  key: String date,
                  value: List<CoinTransactionData> transactions
                ) in coinTransactionsMap.entries) ...[
              SliverToBoxAdapter(
                child: TransactionSectionHeader(
                  date: date,
                ),
              ),
              SliverList.separated(
                itemCount: transactions.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 12.0.s,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  // TODO: Transactions is not implemented
                  return ScreenSideOffset.small(
                    child: TransactionListItem(
                      transactionData: transactions[index],
                      coinData: coinsGroup.coins.first.coin,
                    ),
                  );
                },
              ),
            ],
        ],
      ),
    );
  }
}
