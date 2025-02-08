// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_data.c.dart';
import 'package:ion/app/features/wallets/model/network.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/arrival_time_selector.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_button.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/network_button.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/contact_input_switcher.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/app/utils/num.dart';
import 'package:ion/generated/assets.gen.dart';

class SendCoinsForm extends HookConsumerWidget {
  const SendCoinsForm({super.key});

  static const List<Network> networkTypeValues = Network.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendAssetFormControllerProvider());
    final notifier = ref.watch(sendAssetFormControllerProvider().notifier);
    final selectedContactPubkey = formController.contactPubkey;
    final coin = formController.assetData.as<CoinAssetData>()!;

    final amountController = useTextEditingController.fromValue(
      TextEditingValue(
        text: formatDouble(coin.amount),
      ),
    );
    useEffect(
      () {
        void listener() {
          final maxValue = coin.selectedOption?.amount;
          final numValue = double.tryParse(amountController.value.text);
          if (numValue != null && maxValue != null && numValue > maxValue) {
            amountController.text = maxValue.toString();
          }
        }

        amountController.addListener(listener);

        return () => amountController.removeListener(listener);
      },
      [],
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
                  title: Text(locale.wallet_send_coins),
                  actions: const [
                    NavigationCloseButton(),
                  ],
                ),
              ),
              ScreenSideOffset.small(
                child: Column(
                  children: [
                    if (coin.selectedOption != null)
                      CoinButton(
                        coinInWallet: coin.selectedOption!,
                        onTap: () {
                          CoinSendRoute().push<void>(context);
                        },
                      ),
                    SizedBox(height: 12.0.s),
                    NetworkButton(
                      networkType: formController.network,
                      onTap: () {
                        NetworkSelectSendRoute().push<void>(context);
                      },
                    ),
                    SizedBox(height: 12.0.s),
                    ContactInputSwitcher(
                      pubkey: selectedContactPubkey,
                      onClearTap: (pubkey) => notifier.setContact(null),
                      onContactTap: () async {
                        final pubkey = await CoinsSelectFriendRoute().push<String>(context);

                        if (pubkey != null) {
                          notifier.setContact(pubkey);
                        }
                      },
                    ),
                    SizedBox(height: 12.0.s),
                    CoinAmountInput(
                      controller: amountController,
                      abbreviation: coin.coinsGroup.abbreviation,
                      maxValue: coin.selectedOption!.amount,
                    ),
                    SizedBox(height: 17.0.s),
                    const ArrivalTimeSelector(),
                    SizedBox(height: 45.0.s),
                    Button(
                      label: Text(
                        locale.button_continue,
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
                        ref
                            .read(sendAssetFormControllerProvider().notifier)
                            .setCoinsAmount(amountController.text);
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
