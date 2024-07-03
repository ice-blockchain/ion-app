import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/model/coin_transaction_data.dart';
import 'package:ice/app/features/wallet/model/network_type.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/components/balance/balance.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/components/empty_state/empty_state.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_header.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_list_item.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/components/transaction_list_item/transaction_section_header.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/providers/coin_transactions_provider.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/providers/hooks/use_transactions_by_date.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/coin_details/providers/selectors/coin_transactions_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/delimiter/delimiter.dart';
import 'package:ice/app/features/wallets/providers/selectors/wallets_data_selectors.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class CoinDetailsPage extends IcePage {
  const CoinDetailsPage({required this.payload, super.key});

  final CoinData payload;

  @override
  Widget buildPage(
    BuildContext context,
    WidgetRef ref,
  ) {
    final scrollController = useScrollController();
    final walletId = walletIdSelector(ref);
    final coinId = payload.abbreviation;
    final coinTransactionsMap = useTransactionsByDate(context, ref);
    final isLoading = coinTransactionsIsLoadingSelector(ref);
    final activeNetworkType = useState<NetworkType>(NetworkType.all);

    useOnInit<void>(
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
    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: payload.name,
        titleIcon: payload.iconUrl.icon(),
      ),
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                const Delimiter(),
                Balance(
                  coinData: payload,
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
          if (isLoading) const ListItemsLoadingState(),
          if (coinTransactionsMap.isNotEmpty && !isLoading)
            for (final MapEntry<String, List<CoinTransactionData>>(
                  key: String date,
                  value: List<CoinTransactionData> transactions
                ) in coinTransactionsMap.entries) ...<Widget>[
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
                  return ScreenSideOffset.small(
                    child: TransactionListItem(
                      transactionData: transactions[index],
                      coinData: payload,
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
