// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/wallet_address_notifier_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';

void useCheckWalletAddressAvailable(
  WidgetRef ref, {
  required VoidCallback onAddressMissing,
  List<Object?> keys = const [],
}) {
  useOnInit(
    () async {
      final network = ref.read(receiveCoinsFormControllerProvider).selectedNetwork;
      final address = await ref.read(walletAddressNotifierProvider.notifier).loadWalletAddress();

      if (address != null) {
        ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(address);
      } else if (address == null && network != null && ref.context.mounted) {
        onAddressMissing();
      }
    },
    keys,
  );
}
