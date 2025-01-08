// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/contacts/providers/contacts_provider.c.dart';
import 'package:ion/app/features/wallet/model/network_type.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/arrival_time_selector.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/coin_button.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/network_button.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/contact_input_switcher.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';

class SendCoinsForm extends HookConsumerWidget {
  const SendCoinsForm({super.key});

  static const List<NetworkType> networkTypeValues = NetworkType.values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendAssetFormControllerProvider());
    final notifier = ref.read(sendAssetFormControllerProvider().notifier);
    final selectedContact = formController.selectedContact;

    final amountController = useTextEditingController.fromValue(
      TextEditingValue(
        text: (formController.selectedCoin?.amount ?? 0).toString(),
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
                  title: Text(locale.wallet_send_coins),
                  actions: const [
                    NavigationCloseButton(),
                  ],
                ),
              ),
              ScreenSideOffset.small(
                child: Column(
                  children: [
                    if (formController.selectedCoin != null)
                      CoinButton(
                        coinData: formController.selectedCoin!,
                        onTap: () {
                          CoinSendRoute().push<void>(context);
                        },
                      ),
                    SizedBox(height: 12.0.s),
                    NetworkButton(
                      networkType: formController.selectedNetwork,
                      onTap: () {
                        NetworkSelectSendRoute().push<void>(context);
                      },
                    ),
                    SizedBox(height: 12.0.s),
                    ContactInputSwitcher(
                      contactId: selectedContact?.id,
                      onClearTap: (contactId) => notifier.setContact(null),
                      onContactTap: () async {
                        final pubkey = await CoinsSelectFriendRoute().push<String>(context);

                        if (pubkey != null) {
                          final contact = ref.read(contactByIdProvider(id: pubkey));
                          notifier.setContact(contact);
                        }
                      },
                    ),
                    SizedBox(height: 12.0.s),
                    CoinAmountInput(
                      controller: amountController,
                      coinId: formController.selectedCoin!.abbreviation,
                      showApproximateInUsd: false,
                    ),
                    SizedBox(height: 17.0.s),
                    ArrivalTimeSelector(
                      arrivalTimeInMinutes: formController.arrivalTime,
                      onArrivalTimeChanged: (int value) => ref
                          .read(sendAssetFormControllerProvider().notifier)
                          .updateArrivalTime(value),
                    ),
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
                            .updateAmount(amountController.text);
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
