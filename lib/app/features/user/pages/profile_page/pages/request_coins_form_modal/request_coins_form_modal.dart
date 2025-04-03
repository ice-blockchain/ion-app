// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/list_items_loading_state/item_loading_state.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/select/select_coin_button.dart';
import 'package:ion/app/components/select/select_network_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/user/model/payment_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/user_payment_flow_card/user_payment_flow_card.dart';
import 'package:ion/app/features/user/providers/request_coins_form_provider.c.dart';
import 'package:ion/app/features/user/providers/request_coins_submit_notifier.c.dart';
import 'package:ion/app/features/wallets/model/coin_in_wallet_data.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/features/wallets/views/utils/amount_parser.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class RequestCoinsFormModal extends HookConsumerWidget {
  const RequestCoinsFormModal({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final colors = context.theme.appColors;
    final locale = context.i18n;
    final amountController = useTextEditingController(text: '');
    useListenable(amountController);

    final form = ref.watch(requestCoinsFormControllerProvider);
    final coin = form.assetData.as<CoinAssetToSendData>();

    ref
      ..displayErrors(requestCoinsSubmitNotifierProvider)
      ..listenSuccess(
        requestCoinsSubmitNotifierProvider,
        (_) => Navigator.of(context, rootNavigator: true).pop(),
      );

    final isLoading = ref.watch(requestCoinsSubmitNotifierProvider).isLoading;
    final isButtonDisabled = amountController.text.isEmpty || isLoading;

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
                      SelectCoinButton(
                        selectedCoin: coin?.selectedOption,
                        onTap: () => SelectCoinProfileRoute(paymentType: PaymentType.request)
                            .push<void>(context),
                      ),
                      SizedBox(height: 16.0.s),
                      SelectNetworkButton(
                        selectedNetwork: form.network,
                        onTap: () {
                          if (coin?.selectedOption != null) {
                            SelectNetworkProfileRoute(paymentType: PaymentType.request)
                                .push<void>(context);
                          } else {
                            SelectCoinProfileRoute(paymentType: PaymentType.request)
                                .push<void>(context);
                          }
                        },
                      ),
                      SizedBox(height: 16.0.s),
                      UserPaymentFlowCard(pubkey: form.contactPubkey!),
                      SizedBox(height: 16.0.s),
                      if (coin?.selectedOption case final CoinInWalletData coinInWallet)
                        CoinAmountInput(
                          balanceUSD: (parseAmount(amountController.text) ?? 0) *
                              coinInWallet.coin.priceUSD,
                          controller: amountController,
                          coinAbbreviation: coinInWallet.coin.abbreviation,
                        )
                      else
                        ItemLoadingState(itemHeight: 60.0.s),
                      SizedBox(height: 16.0.s),
                      Button(
                        type: isButtonDisabled ? ButtonType.disabled : ButtonType.primary,
                        disabled: isButtonDisabled,
                        label: Text(locale.button_request),
                        mainAxisSize: MainAxisSize.max,
                        trailingIcon: isLoading
                            ? const IONLoadingIndicator()
                            : ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  colors.primaryBackground,
                                  BlendMode.srcIn,
                                ),
                                child: Assets.svg.iconButtonNext.icon(),
                              ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ref.read(requestCoinsSubmitNotifierProvider.notifier).submitRequest();
                          }
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
