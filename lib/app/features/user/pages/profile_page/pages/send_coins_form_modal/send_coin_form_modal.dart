// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/user_payment_flow_card/user_payment_flow_card.dart';
import 'package:ion/app/features/user/pages/profile_page/hooks/use_state_with_init_value_from_provider.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/common/profile_coin_button.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/common/profile_network_button.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/arrival_time_selector.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SendCoinFormModal extends HookConsumerWidget {
  const SendCoinFormModal({
    required this.pubkey,
    required this.networkId,
    required this.coinSymbolGroup,
    required this.coinAbbreviation,
    super.key,
  });

  final String pubkey;
  final String networkId;
  final String coinSymbolGroup;
  final String coinAbbreviation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.i18n;
    final colors = context.theme.appColors;

    final selectedCoinInWallet = useStateWithInitValueFromProvider(
      ref,
      coinInWalletProvider(
        networkId: networkId,
        symbolGroup: coinSymbolGroup,
        abbreviation: coinAbbreviation,
      ),
    );

    final amountController = useTextEditingController(text: '');
    final formKey = useMemoized(GlobalKey<FormState>.new);
    useListenable(amountController);

    Future<void> loadSelectedCoin({
      required String networkId,
      required String symbolGroup,
      required String abbreviation,
    }) async {
      final newCoin = await ref.read(
        coinInWalletProvider(
          networkId: networkId,
          symbolGroup: symbolGroup,
          abbreviation: abbreviation,
        ).future,
      );

      if (newCoin != null) {
        selectedCoinInWallet.value = newCoin;
      }
    }

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: NavigationAppBar.screen(
                  title: Text(locale.profile_send_coin),
                  actions: const [
                    NavigationCloseButton(),
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: ScreenSideOffset.small(
                  child: Column(
                    children: [
                      ProfileCoinButton(
                        pubkey: pubkey,
                        paymentType: PaymentType.send,
                        coinInWalletData: selectedCoinInWallet.value,
                        onUpdate: (group) {
                          final coin = selectedCoinInWallet.value?.coin;

                          if (coin == null) return;

                          final networks = group.coins.map((e) => e.coin.network);
                          final useNetworkFromPrevCoin = networks.contains(coin.network);

                          unawaited(
                            loadSelectedCoin(
                              networkId:
                                  useNetworkFromPrevCoin ? coin.network.id : networks.first.id,
                              symbolGroup: group.symbolGroup,
                              abbreviation: group.abbreviation,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.0.s),
                      ProfileNetworkButton(
                        pubkey: pubkey,
                        paymentType: PaymentType.send,
                        coinInWallet: selectedCoinInWallet.value,
                        onUpdate: (network) {
                          final coin = selectedCoinInWallet.value?.coin;

                          if (coin == null) return;

                          unawaited(
                            loadSelectedCoin(
                              networkId: network.id,
                              symbolGroup: coin.symbolGroup,
                              abbreviation: coin.abbreviation,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.0.s),
                      UserPaymentFlowCard(pubkey: pubkey),
                      SizedBox(height: 16.0.s),
                      if (selectedCoinInWallet.value case final CoinInWalletData coin)
                        CoinAmountInput(
                          controller: amountController,
                          coinAbbreviation: coin.coin.abbreviation,
                          balanceUSD:
                              (double.tryParse(amountController.text) ?? 0) * coin.coin.priceUSD,
                        )
                      else
                        ItemLoadingState(itemHeight: 60.0.s),
                      SizedBox(height: 16.0.s),
                      const NetworkFeeSelector(),
                      SizedBox(height: 45.0.s),
                      Button(
                        type: amountController.text.isEmpty
                            ? ButtonType.disabled
                            : ButtonType.primary,
                        disabled: amountController.text.isEmpty,
                        label: Text(
                          locale.button_send,
                        ),
                        mainAxisSize: MainAxisSize.max,
                        trailingIcon: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            colors.primaryBackground,
                            BlendMode.srcIn,
                          ),
                          child: Assets.svg.iconButtonNext.icon(),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {}
                        },
                      ),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
