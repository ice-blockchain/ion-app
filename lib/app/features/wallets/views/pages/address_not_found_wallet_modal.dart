// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/model/crypto_asset_type.dart';
import 'package:ion/app/features/wallets/views/components/address_not_found_modal.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/receive_nft/providers/receive_nft_form_notifier.c.dart';

class AddressNotFoundWalletModal extends HookConsumerWidget {
  const AddressNotFoundWalletModal({
    required this.onWalletCreated,
    this.assetType = CryptoAssetType.coin,
    super.key,
  });

  final ValueChanged<BuildContext> onWalletCreated;
  final CryptoAssetType assetType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNetwork = switch (assetType) {
      CryptoAssetType.coin => ref.watch(
          receiveCoinsFormControllerProvider.select((state) => state.selectedNetwork),
        ),
      CryptoAssetType.nft => ref.watch(
          receiveNftFormNotifierProvider.select((state) => state.selectedNetwork),
        ),
    };

    return AddressNotFoundModal(
      network: selectedNetwork,
      onWalletCreated: (walletAddress) {
        switch (assetType) {
          case CryptoAssetType.coin:
            ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(walletAddress);
          case CryptoAssetType.nft:
            ref.read(receiveNftFormNotifierProvider.notifier).setWalletAddress(walletAddress);
        }
        onWalletCreated(ref.context);
      },
    );
  }
}
