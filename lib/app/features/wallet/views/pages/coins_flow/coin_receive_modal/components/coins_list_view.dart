import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/coin_data.dart';
import 'package:ice/app/features/wallet/providers/coins_provider.dart';
import 'package:ice/app/features/wallet/providers/hooks/use_filtered_wallet_coins.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/coins/coin_item.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/providers/wallet_page_selectors.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/tab_type.dart';
import 'package:ice/app/features/wallets/providers/wallets_data_provider.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

enum CoinsListViewType { send, receive }

class CoinsListView extends HookConsumerWidget {
  const CoinsListView({
    required this.onCoinItemTap,
    this.type = CoinsListViewType.send,
    super.key,
  });

  final void Function(CoinData coin) onCoinItemTap;
  final CoinsListViewType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = useFilteredWalletCoins(ref);
    final searchValue = walletAssetSearchValueSelector(ref, WalletTabType.coins);
    final walletId = ref.watch(walletRepositoryProvider).currentWalletId;

    useOnInit<void>(
      () {
        if (walletId.isNotEmpty) {
          ref
              .read(coinsNotifierProvider.notifier)
              .fetch(searchValue: searchValue, walletId: walletId);
        }
      },
      <Object?>[searchValue, walletId],
    );

    if (coins.isEmpty) {
      return const SizedBox.shrink();
    }

    final title = type == CoinsListViewType.receive
        ? context.i18n.wallet_receive_coins
        : context.i18n.wallet_send_coins;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.s),
          child: NavigationAppBar.screen(
            title: Text(title),
            showBackButton: false,
            actions: const [
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
                    ref.read(receiveCoinsFormControllerProvider.notifier).selectCoin(coins[index]);
                    onCoinItemTap(coins[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
