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
import 'package:ion/app/features/wallets/model/entities/wallet_asset_entity.c.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coin_transactions_form_notifier_provider.c.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/balance/balance.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/empty_state/empty_state.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_header.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_item.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_section_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/utils/date.dart';

class CoinDetailsPage extends HookConsumerWidget {
  CoinDetailsPage({required this.symbolGroup, super.key});

  final String symbolGroup;
  final Set<WalletAssetEntity> entities = {};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final walletView = ref.watch(currentWalletViewDataProvider).requireValue;
    final coinsGroup = walletView.coinGroups.firstWhere((e) => e.symbolGroup == symbolGroup);
    final form = ref.watch(coinTransactionsFormNotifierProvider(symbolGroup: symbolGroup));

    final isTransactionsLoading = form == null;

    final coinTransactionsMap = useMemoized(
      () => groupBy(
        form?.transactions ?? <CoinTransactionData>[],
        (CoinTransactionData tx) => toPastDateDisplayValue(tx.timestamp, context),
      ),
      [form, context],
    );

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
          if (form?.selectedNetwork case final NetworkData selectedNetwork)
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const Delimiter(),
                  Balance(
                    coinsGroup: coinsGroup,
                    network: selectedNetwork,
                  ),
                  const Delimiter(),
                ],
              ),
            ),
          if (form != null)
            SliverToBoxAdapter(
              child: TransactionListHeader(
                networks: form.networks,
                selectedNetwork: form.selectedNetwork,
                onNetworkTypeSelect: (NetworkData newNetwork) {
                  ref
                      .read(
                        coinTransactionsFormNotifierProvider(symbolGroup: symbolGroup).notifier,
                      )
                      .network = newNetwork;
                },
              ),
            ),
          if (coinTransactionsMap.isEmpty && !isTransactionsLoading) const EmptyState(),
          if (isTransactionsLoading)
            ListItemsLoadingState(
              itemsCount: 7,
              separatorHeight: 12.0.s,
              listItemsLoadingStateType: ListItemsLoadingStateType.scrollView,
            ),
          if (coinTransactionsMap.isNotEmpty && !isTransactionsLoading)
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
                separatorBuilder: (BuildContext context, int index) => SizedBox(height: 12.0.s),
                itemBuilder: (BuildContext context, int index) {
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
