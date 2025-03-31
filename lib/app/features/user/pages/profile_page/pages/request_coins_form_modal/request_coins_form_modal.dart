// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/pages/profile_page/components/user_payment_flow_card/user_payment_flow_card.dart';
import 'package:ion/app/features/user/pages/profile_page/hooks/use_state_with_init_value_from_provider.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/providers/coins_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class RequestCoinsFormModal extends HookConsumerWidget {
  const RequestCoinsFormModal({
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
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final colors = context.theme.appColors;
    final locale = context.i18n;
    final amountController = useTextEditingController(text: '');
    useListenable(amountController);

    final selectedCoinInWallet = useStateWithInitValueFromProvider(
      ref,
      coinInWalletProvider(
        networkId: networkId,
        symbolGroup: coinSymbolGroup,
        abbreviation: coinAbbreviation,
      ),
    );

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: NavigationAppBar.screen(
                  title: Text(locale.profile_request_funds),
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
                      // TODO: Add CoinButton
                      SizedBox(height: 16.0.s),
                      // TODO: Add NetworkButton
                      SizedBox(height: 16.0.s),
                      UserPaymentFlowCard(pubkey: pubkey),
                      SizedBox(height: 16.0.s),
                      if (selectedCoinInWallet.value case final CoinInWalletData coinInWallet)
                        CoinAmountInput(
                          balanceUSD: (double.tryParse(amountController.text) ?? 0) *
                              coinInWallet.coin.priceUSD,
                          controller: amountController,
                          coinAbbreviation: coinInWallet.coin.abbreviation,
                        )
                      else
                        ItemLoadingState(itemHeight: 60.0.s),
                      SizedBox(height: 45.0.s),
                      Button(
                        type: amountController.text.isEmpty
                            ? ButtonType.disabled
                            : ButtonType.primary,
                        disabled: amountController.text.isEmpty,
                        label: Text(
                          locale.button_request,
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
