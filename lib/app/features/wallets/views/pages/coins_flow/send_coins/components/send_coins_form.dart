// SPDX-License-Identifier: ice License 1.0

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/select/select_coin_button.dart';
import 'package:ion/app/components/select/select_network_button.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/extensions/object.dart';
import 'package:ion/app/features/user/pages/profile_page/components/user_payment_flow_card/user_payment_flow_card.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_to_send_data.c.dart';
import 'package:ion/app/features/wallets/providers/send_asset_form_provider.c.dart';
import 'package:ion/app/features/wallets/utils/wallet_address_validator.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/coin_amount_input.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/coins_network_fee_selector.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/contact_input_switcher.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/widgets/not_enough_coins_for_network_fee_message.dart';
import 'package:ion/app/features/wallets/views/pages/contact_wallet_error_modals.dart';
import 'package:ion/app/features/wallets/views/utils/amount_parser.dart';
import 'package:ion/app/features/wallets/views/utils/crypto_formatter.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class SendCoinsForm extends HookConsumerWidget {
  const SendCoinsForm({
    required this.selectCoinRouteLocationBuilder,
    required this.selectNetworkRouteLocationBuilder,
    required this.confirmRouteLocationBuilder,
    this.scanAddressRouteLocationBuilder,
    this.selectContactRouteLocationBuilder,
    super.key,
  });

  final String Function() selectCoinRouteLocationBuilder;
  final String Function() selectNetworkRouteLocationBuilder;
  final String Function(String networkId)? selectContactRouteLocationBuilder;
  final String Function()? scanAddressRouteLocationBuilder;
  final String Function() confirmRouteLocationBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.theme.appColors;
    final locale = context.i18n;

    final formController = ref.watch(sendAssetFormControllerProvider);
    final notifier = ref.watch(sendAssetFormControllerProvider.notifier);
    final selectedContactPubkey = formController.contactPubkey;
    final coin = formController.assetData.as<CoinAssetToSendData>();
    final maxAmount = coin?.selectedOption?.amount ?? 0;

    final amountController = useTextEditingController.fromValue(
      TextEditingValue(
        text: formatCrypto(coin?.amount ?? 0),
      ),
    );

    if (formController.isContactPreselected) {
      _listenContactWallet(ref, formController.contactPubkey);
    }

    useOnInit(
      () {
        void listener() {
          final numValue = parseAmount(amountController.value.text);
          final isValidAmount = numValue != null && numValue <= maxAmount && numValue > 0;
          notifier.setCoinsAmount(isValidAmount ? amountController.text : '');
        }

        amountController.addListener(listener);
      },
      [amountController],
    );

    final validAmount = formController.assetData.maybeMap(
      coin: (coin) => coin.amount > 0,
      orElse: () => false,
    );

    final network = useRef(formController.network);
    final validator = useRef(WalletAddressValidator(network.value?.id ?? ''));

    final isContinueButtonEnabled = formController.canCoverNetworkFee &&
        validAmount &&
        formController.senderWallet?.address != null &&
        validator.value.validate(formController.receiverAddress);

    return SheetContent(
      body: KeyboardDismissOnTap(
        child: Column(
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
            Expanded(
              child: SingleChildScrollView(
                child: ScreenSideOffset.small(
                  child: Column(
                    children: [
                      SelectCoinButton(
                        selectedCoin: coin?.selectedOption,
                        enabled: formController.request == null,
                        onTap: () => context.push(selectCoinRouteLocationBuilder()),
                      ),
                      SizedBox(height: 12.0.s),
                      SelectNetworkButton(
                        selectedNetwork: formController.network,
                        enabled: formController.request == null,
                        onTap: () {
                          if (coin?.selectedOption != null) {
                            context.push(selectNetworkRouteLocationBuilder());
                          } else {
                            context.push(selectCoinRouteLocationBuilder());
                          }
                        },
                      ),
                      SizedBox(height: 12.0.s),
                      if (formController.isContactPreselected &&
                          formController.contactPubkey != null)
                        UserPaymentFlowCard(pubkey: formController.contactPubkey!)
                      else
                        ContactInputSwitcher(
                          pubkey: selectedContactPubkey,
                          address: formController.receiverAddress,
                          network: formController.network,
                          onClearTap: (pubkey) {
                            notifier
                              ..setContact(null)
                              ..setReceiverAddress('');
                          },
                          onWalletAddressChanged: (String? value) {
                            if (value != null) {
                              notifier.setReceiverAddress(value);
                            }
                          },
                          onContactTap: () async {
                            final pubkey = await context.push<String>(
                              selectContactRouteLocationBuilder!(formController.network!.id),
                            );

                            if (pubkey != null) notifier.setContact(pubkey);
                          },
                          onScanPressed: () async {
                            final address = await context.push<String?>(
                              scanAddressRouteLocationBuilder!(),
                            );
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
                        enabled: formController.request == null,
                      ),
                      SizedBox(height: 17.0.s),
                      const CoinsNetworkFeeSelector(),
                      if (formController.canCoverNetworkFee)
                        SizedBox(height: 45.0.s)
                      else if (formController.networkNativeToken
                          case final WalletAsset networkToken)
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
                        onPressed: () => context.push(confirmRouteLocationBuilder()),
                      ),
                      SizedBox(height: 16.0.s),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _listenContactWallet(WidgetRef ref, String? contactPubkey) async {
    if (contactPubkey == null) {
      return;
    }

    ref.listen(
      sendAssetFormControllerProvider.select((formState) => formState.network),
      (_, network) async {
        if (network == null) {
          return;
        }

        final user = await ref.read(userMetadataProvider(contactPubkey).future);
        final walletsMap = user?.data.wallets;

        final hasProperWallet = walletsMap?[network.id] != null;
        if (!hasProperWallet && ref.context.mounted) {
          unawaited(
            showContactWalletError(
              ref.context,
              user: user!,
              network: network,
              isPrivate: walletsMap == null,
            ),
          );
        }
      },
    );
  }
}
