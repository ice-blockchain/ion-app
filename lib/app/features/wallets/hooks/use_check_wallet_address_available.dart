// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/verify_identity/verify_identity_prompt_dialog_helper.dart';
import 'package:ion/app/features/wallets/model/network_data.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/receive_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/receive_coins/providers/wallet_address_notifier_provider.c.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion_identity_client/ion_identity.dart';

void useCheckWalletAddressAvailable(
  WidgetRef ref, {
  required VoidCallback onAddressMissing,
  List<Object?> keys = const [],
}) {
  useOnInit(
    () async {
      final network = ref.read(receiveCoinsFormControllerProvider).selectedNetwork;
      final address = await ref.read(walletAddressNotifierProvider.notifier).loadWalletAddress();

      if (!ref.context.mounted) return;

      if (address != null) {
        ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(address);
      } else if (address == null && network?.displayName == 'ION') {
        _createIonWallet(ref, network!);
      } else if (address == null && network != null) {
        onAddressMissing();
      }
    },
    keys,
  );
}

void _createIonWallet(
  WidgetRef ref,
  NetworkData network,
) {
  guardPasskeyDialog(
    ref.context,
    (child) {
      return RiverpodVerifyIdentityRequestBuilder(
        provider: walletAddressNotifierProvider,
        requestWithVerifyIdentity: (OnVerifyIdentity<Wallet> onVerifyIdentity) async {
          final address = await ref
              .read(
                walletAddressNotifierProvider.notifier,
              )
              .createWallet(
                onVerifyIdentity: onVerifyIdentity,
                network: network,
              );

          if (address != null) {
            ref.read(receiveCoinsFormControllerProvider.notifier).setWalletAddress(address);
          }
        },
        child: child,
      );
    },
  );
}
