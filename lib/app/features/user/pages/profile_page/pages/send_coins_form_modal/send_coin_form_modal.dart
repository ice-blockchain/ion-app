// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/user_payment_flow_card/user_payment_flow_card.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_coin_modal/select_coin_modal.dart';
import 'package:ion/app/features/user/pages/profile_page/pages/select_network_modal/select_network_modal.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/providers/wallet_view_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/arrival_time_selector.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_id_button.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/network_button.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SendCoinFormModal extends HookConsumerWidget {
  const SendCoinFormModal({
    required this.pubkey,
    required this.networkName,
    required this.coinAbbreviation,
    super.key,
  });

  final String pubkey;
  final String networkName;
  final String coinAbbreviation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final selectedNetworkType = useState(Network(name: networkName));
    final selectedCoinAbbreviation = useState(coinAbbreviation);

    final amountController = useTextEditingController(text: '');
    useListenable(amountController);

    final walletBalance = ref.watch(currentWalletViewDataProvider).valueOrNull?.usdBalance;

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
                  showBackButton: false,
                  actions: [
                    NavigationCloseButton(
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: ScreenSideOffset.small(
                  child: Column(
                    children: [
                      CoinIdButton(
                        coinAbbreviation: selectedCoinAbbreviation.value,
                        onTap: () async {
                          final newCoinAbbreviation = await SelectCoinRoute(
                            paymentType: PaymentType.send,
                            pubkey: pubkey,
                            selectCoinModalType: SelectCoinModalType.update,
                          ).push<String>(context);
                          if (newCoinAbbreviation != null && context.mounted) {
                            selectedCoinAbbreviation.value = newCoinAbbreviation;
                          }
                        },
                      ),
                      SizedBox(height: 16.0.s),
                      NetworkButton(
                        networkType: selectedNetworkType.value,
                        onTap: () async {
                          final newNetwork = await SelectNetworkRoute(
                            paymentType: PaymentType.send,
                            pubkey: pubkey,
                            coinAbbreviation: selectedCoinAbbreviation.value,
                            selectNetworkModalType: SelectNetworkModalType.update,
                          ).push<Network>(context);
                          if (newNetwork != null && context.mounted) {
                            selectedNetworkType.value = newNetwork;
                          }
                        },
                      ),
                      SizedBox(height: 16.0.s),
                      UserPaymentFlowCard(
                        pubkey: pubkey,
                      ),
                      SizedBox(height: 16.0.s),
                      CoinAmountInput(
                        controller: amountController,
                        coinAbbreviation: selectedCoinAbbreviation.value,
                        balanceUSD: walletBalance,
                      ),
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
