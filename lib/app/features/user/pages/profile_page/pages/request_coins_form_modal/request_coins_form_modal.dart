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
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/coin_id_button.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/network_button.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class RequestCoinsFormModal extends HookConsumerWidget {
  const RequestCoinsFormModal({
    required this.pubkey,
    required this.coinId,
    required this.networkType,
    super.key,
  });

  final String pubkey;
  final String coinId;
  final NetworkType networkType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final selectedNetworkType = useState(networkType);
    final selectedCoinId = useState(coinId);
    final amountController = useTextEditingController(text: '');
    useListenable(amountController);

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
                        coinId: selectedCoinId.value,
                        onTap: () async {
                          final newCoinId = await SelectCoinRoute(
                            paymentType: PaymentType.receive,
                            pubkey: pubkey,
                            selectCoinModalType: SelectCoinModalType.update,
                          ).push<String>(context);
                          if (newCoinId != null && context.mounted) {
                            selectedCoinId.value = newCoinId;
                          }
                        },
                      ),
                      SizedBox(height: 16.0.s),
                      NetworkButton(
                        networkType: selectedNetworkType.value,
                        onTap: () async {
                          final newNetworkType = await SelectNetworkRoute(
                            paymentType: PaymentType.receive,
                            pubkey: pubkey,
                            coinId: selectedCoinId.value,
                            selectNetworkModalType: SelectNetworkModalType.update,
                          ).push<NetworkType>(context);
                          if (newNetworkType != null && context.mounted) {
                            selectedNetworkType.value = newNetworkType;
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
                        coinId: selectedCoinId.value,
                        showApproximateInUsd: false,
                        showMaxAction: false,
                      ),
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
