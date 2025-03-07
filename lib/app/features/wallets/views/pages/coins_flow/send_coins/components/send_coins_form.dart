// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/select/select_coin_button.dart';
import 'package:ion/app/components/select/select_network_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/arrival_time_selector.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/contact_input_switcher.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/widgets/not_enough_coins_for_network_fee_message.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class SendCoinsForm extends HookConsumerWidget {
  const SendCoinsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendAssetFormControllerProvider());
    final notifier = ref.watch(sendAssetFormControllerProvider().notifier);
    final selectedContactPubkey = formController.contactPubkey;
    final coin = formController.assetData.as<CoinAssetData>();
    final maxAmount = coin?.selectedOption?.amount ?? 0;

    final amountController = useTextEditingController.fromValue(
      TextEditingValue(
        text: formatCrypto(coin?.amount ?? 0),
      ),
    );

    useOnInit(
      () {
        void listener() {
          final numValue = double.tryParse(amountController.value.text);
          if (numValue != null && numValue > maxAmount) {
            amountController.text = formatCrypto(maxAmount);
          }
          notifier.setCoinsAmount(amountController.text);
        }

        amountController.addListener(listener);
      },
      [amountController],
    );

    final validAmount = formController.assetData.maybeMap(
      coin: (coin) => coin.amount > 0,
      orElse: () => false,
    );

    final isContinueButtonEnabled = formController.canCoverNetworkFee &&
        validAmount &&
        formController.receiverAddress.isNotEmpty &&
        formController.senderWallet?.address != null;

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0.s),
                child: NavigationAppBar.screen(
                  title: Text(locale.wallet_send_coins),
                  actions: const [
                    NavigationCloseButton(),
                  ],
                ),
              ),
              ScreenSideOffset.small(
                child: Column(
                  children: [
                    SelectCoinButton(
                      selectedCoin: coin?.selectedOption,
                      onTap: () => CoinSendRoute().push<void>(context),
                    ),
                    SizedBox(height: 12.0.s),
                    SelectNetworkButton(
                      selectedNetwork: formController.network,
                      onTap: () {
                        if (coin?.selectedOption != null) {
                          NetworkSelectSendRoute().push<void>(context);
                        } else {
                          CoinSendRoute().push<void>(context);
                        }
                      },
                    ),
                    SizedBox(height: 12.0.s),
                    ContactInputSwitcher(
                      pubkey: selectedContactPubkey,
                      address: formController.receiverAddress,
                      onClearTap: (pubkey) {
                        notifier
                          ..setContact(null)
                          ..setReceiverAddress('');
                      },
                      onWalletAddressChanged: (String? value) {
                        if (value != null && value.isNotEmpty) {
                          notifier.setReceiverAddress(value);
                        }
                      },
                      onContactTap: () async {
                        final pubkey = await CoinsSelectContactRoute(
                          networkId: formController.network!.id,
                        ).push<String>(context);

                        if (pubkey != null) notifier.setContact(pubkey);
                      },
                      onScanPressed: () async {
                        final address = await CoinSendScanRoute().push<String?>(context);
                        if (address != null) {
                          notifier.setReceiverAddress(address);
                        }
                      },
                    ),
                    SizedBox(height: 12.0.s),
                    CoinAmountInput(
                      controller: amountController,
                      maxValue: coin?.selectedOption?.amount ?? 0,
                      coinAbbreviation: coin?.coinsGroup.abbreviation ?? '',
                    ),
                    SizedBox(height: 17.0.s),
                    const NetworkFeeSelector(),
                    if (formController.canCoverNetworkFee)
                      SizedBox(height: 45.0.s)
                    else if (formController.networkNativeToken case final WalletAsset networkToken)
                      NotEnoughMoneyForNetworkFeeMessage(
                        coinAsset: coin!,
                        networkToken: networkToken,
                        network: formController.network!,
                      ),
                    Button(
                      label: Text(
                        locale.button_continue,
                      ),
                      type: isContinueButtonEnabled ? ButtonType.primary : ButtonType.disabled,
                      mainAxisSize: MainAxisSize.max,
                      disabled: !isContinueButtonEnabled,
                      trailingIcon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          colors.primaryBackground,
                          BlendMode.srcIn,
                        ),
                        child: Assets.svg.iconButtonNext.icon(),
                      ),
                      onPressed: () {
                        CoinsSendFormConfirmationRoute().push<void>(context);
                      },
                    ),
                    SizedBox(height: 16.0.s),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
