// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallets/hooks/use_check_wallet_address_available.dart';
import 'package:ion/app/features/wallets/views/components/share_address/share_address_sheet_content.dart';
import 'package:ion/app/features/wallets/views/pages/receive_nft/providers/receive_nft_form_notifier.r.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class ShareAddressToGetNftView extends HookConsumerWidget {
  const ShareAddressToGetNftView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(receiveNftFormNotifierProvider);

    useCheckWalletAddressAvailable(
      ref,
      network: form.selectedNetwork,
      coinsGroup: null,
      onAddressFound: (address) {
        ref.read(receiveNftFormNotifierProvider.notifier).setWalletAddress(address);
      },
      onAddressMissing: () => AddressNotFoundReceiveNftRoute().replace(ref.context),
      keys: [form.selectedNetwork],
    );

    return ShareAddressSheetContent(
      coin: null,
      network: form.selectedNetwork!,
      walletAddress: form.address,
    );
  }
}
