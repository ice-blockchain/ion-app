// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/views/components/address_not_found_modal.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';

class AddressNotFoundWalletModal extends HookConsumerWidget {
  const AddressNotFoundWalletModal({
    required this.onWalletCreated,
    super.key,
  });

  final ValueChanged<BuildContext> onWalletCreated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNetwork = ref.watch(
      receiveCoinsFormControllerProvider.select((state) => state.selectedNetwork),
    );

    return AddressNotFoundModal(
      network: selectedNetwork,
      onWalletCreated: (walletAddress) {
        ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(walletAddress);
        onWalletCreated(ref.context);
      },
    );
  }
}
