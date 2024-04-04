import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/coin_transaction_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/providers/wallet_data_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/transaction_list_item/section_header.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/transaction_list_item/transaction_list_header.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/transaction_list_item/transaction_list_item.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/components/transaction_list_item/transaction_list_loading_state.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/providers/coin_transactions_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/providers/hooks/use_transactions_by_date.dart';
import 'package:ice/app/features/wallet/views/pages/coin_details/providers/selectors/coin_transactions_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class CoinDetailsPage extends IcePage<CoinData> {
  const CoinDetailsPage(super.route, super.payload);

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
    CoinData? coinData,
  ) {
    final ScrollController scrollController = useScrollController();
    final String walletId = walletIdSelector(ref);
    final String coinId = coinData?.abbreviation ?? '';
    final Map<String, List<CoinTransactionData>> coinTransactionsMap =
        useTransactionsByDate(context, ref);
    final bool isLoading = coinTransactionsIsLoadingSelector(ref);
    final ValueNotifier<NetworkType> activeNetworkType =
        useState<NetworkType>(NetworkType.all);

    useOnInit(
      () {
        if (walletId.isNotEmpty && coinId.isNotEmpty) {
          ref.read(coinTransactionsNotifierProvider.notifier).fetch(
                walletId: walletId,
                coinId: coinId,
                networkType: activeNetworkType.value,
              );
        }
      },
      <Object?>[walletId, coinId, activeNetworkType.value],
    );

    if (coinData == null) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: coinData.name,
        titleIcon: coinData.iconUrl.icon(),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Delimiter(),
                Balance(
                  coinData: coinData,
                  networkType: activeNetworkType.value,
                ),
                const Delimiter(),
              ],
            ),
          ),
          if (coinTransactionsMap.isEmpty && !isLoading) const EmptyState(),
          if (coinTransactionsMap.isNotEmpty || isLoading)
            SliverToBoxAdapter(
              child: TransactionListHeader(
                selectedNetworkType: activeNetworkType.value,
                onNetworkTypeSelect: (NetworkType newNetworkType) =>
                    activeNetworkType.value = newNetworkType,
              ),
            ),
          if (isLoading) const TransactionListLoadingState(),
          if (coinTransactionsMap.isNotEmpty)
            for (final MapEntry<String, List<CoinTransactionData>>(
                  key: String date,
                  value: List<CoinTransactionData> transactions
                ) in coinTransactionsMap.entries) ...<Widget>[
              SliverToBoxAdapter(
                child: SectionHeader(
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
                  return ScreenSideOffset.small(
                    child: TransactionListItem(
                      transactionData: transactions[index],
                      coinData: coinData,
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
