// SPDX-License-Identifier: ice License 1.0

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/button.dart';
import 'package:ion/app/components/progress_bar/ion_loading_indicator.dart';
import 'package:ion/app/components/screen_offset/screen_bottom_offset.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/providers/coins_by_filters_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/network_icon_widget.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/wallet_address_notifier_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';
import 'package:ion/generated/assets.gen.dart';
import 'package:ion_identity_client/ion_identity.dart';

class AddressNotFoundModal extends HookConsumerWidget {
  const AddressNotFoundModal({required this.onContinue, super.key});

  final void Function(BuildContext context) onContinue;

  static double get buttonsSize => 56.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonMinimalSize = Size(buttonsSize, buttonsSize);

    final coinsGroup = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedCoin),
    )!;
    final selectedNetwork = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedNetwork),
    );

    final coinsWithNetworkOptions = ref.watch(
      coinsByFiltersProvider(
        symbol: coinsGroup.abbreviation,
        symbolGroup: coinsGroup.symbolGroup,
      ),
    );

    final isCreatingWallet = ref.watch(
      walletAddressNotifierProvider.select((state) => state.isLoading),
    );

    useOnInit(
      () {
        if (selectedNetwork == null) {
          coinsWithNetworkOptions.maybeWhen(
            data: (options) {
              var coinInWallet = options.firstWhereOrNull(
                (coinInWallet) => coinInWallet.walletId != null,
              );
              coinInWallet ??= options.firstOrNull;

              if (coinInWallet != null) {
                ref
                    .read(receiveCoinsFormControllerProvider.notifier)
                    .setNetwork(coinInWallet.coin.network);
              }
            },
            orElse: () {},
          );
        }
      },
      [coinsWithNetworkOptions],
    );

    final networkDisplayName = selectedNetwork?.displayName ?? '';

    return SheetContent(
      body: ScreenSideOffset.small(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NavigationAppBar.modal(
              title: Text(context.i18n.wallet_address_not_found),
              actions: const [NavigationCloseButton()],
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 22.0.s, bottom: 4.0.s),
              child: _WalletNetworkIcon(
                networkIconUrl: selectedNetwork?.image ?? '',
              ),
            ),
            Text(
              context.i18n.wallet_address_set_up(networkDisplayName),
              style: context.theme.appTextThemes.title.copyWith(
                color: context.theme.appColors.primaryText,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: 8.0.s,
                bottom: 21.0.s,
                start: 10.0.s,
                end: 10.0.s,
              ),
              child: Text(
                context.i18n.wallet_address_create_one(networkDisplayName),
                style: context.theme.appTextThemes.body2.copyWith(
                  color: context.theme.appColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ScreenBottomOffset(
              child: Button(
                label: Text(context.i18n.wallet_address_create_button),
                leadingIcon: Assets.svg.iconPostAddanswer.icon(
                  size: 24.0.s,
                  color: context.theme.appColors.onPrimaryAccent,
                ),
                trailingIcon: isCreatingWallet ? const IONLoadingIndicator() : null,
                onPressed: () => _createWalletAddress(ref, selectedNetwork),
                minimumSize: buttonMinimalSize,
                mainAxisSize: MainAxisSize.max,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createWalletAddress(WidgetRef ref, NetworkData? network) async {
    if (network == null) return;
    String? address;
    await guardPasskeyDialog(
      ref.context,
      (child) {
        return RiverpodVerifyIdentityRequestBuilder(
          provider: walletAddressNotifierProvider,
          requestWithVerifyIdentity: (OnVerifyIdentity<Wallet> onVerifyIdentity) async {
            address = await ref
                .read(
                  walletAddressNotifierProvider.notifier,
                )
                .createWallet(
                  onVerifyIdentity: onVerifyIdentity,
                  network: network,
                );
          },
          child: child,
        );
      },
    );

    if (address != null && ref.context.mounted) {
      ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(address!);
      onContinue(ref.context);
    }
  }
}

class _WalletNetworkIcon extends StatelessWidget {
  const _WalletNetworkIcon({required this.networkIconUrl});

  final String networkIconUrl;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Assets.svg.actionwalletsetupnetwork.icon(size: 80.0.s),
        PositionedDirectional(
          bottom: 0,
          start: 4.0.s,
          child: NetworkIconWidget(
            size: 22.0.s,
            imageUrl: networkIconUrl,
          ),
        ),
      ],
    );
  }
}
