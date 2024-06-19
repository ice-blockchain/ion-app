import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/providers/coins_provider.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_coins.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coin_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/features/wallets/providers/selectors/wallets_data_selectors.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class CoinsListView extends HookConsumerWidget {
  const CoinsListView({
    required this.coinTap,
    super.key,
  });

  final Function(CoinData) coinTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = useFilteredWalletCoins(ref);
    final searchValue = walletAssetSearchValueSelector(ref, WalletTabType.coins);
    final walletId = walletIdSelector(ref);

    useOnInit<void>(
      () {
        if (walletId.isNotEmpty) {
          ref.read(coinsNotifierProvider.notifier).fetch(searchValue: searchValue, walletId: walletId);
        }
      },
      <Object?>[searchValue, walletId],
    );

    if (coins.isEmpty) {
      return const SizedBox.shrink();
    }

    return FractionallySizedBox(
      heightFactor: 0.79,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: context.i18n.wallet_send_coins,
              showBackButton: false,
              actions: const <Widget>[
                NavigationCloseButton(),
              ],
            ),
          ),
          ScreenSideOffset.small(
            child: SearchInput(
              onTextChanged: (String value) {},
            ),
          ),
          SizedBox(
            height: 12.0.s,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: coins.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 12.0.s,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return ScreenSideOffset.small(
                  child: CoinItem(
                    coinData: coins[index],
                    onTap: () {
                      coinTap(coins[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
