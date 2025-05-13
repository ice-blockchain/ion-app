// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/request_coins_form_provider.c.dart';
import 'package:ion/app/features/wallets/views/components/address_not_found_modal.dart';

class AddressNotFoundChatModal extends HookConsumerWidget {
  const AddressNotFoundChatModal({
    required this.onWalletCreated,
    super.key,
  });

  final ValueChanged<BuildContext> onWalletCreated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNetwork = ref.watch(
      requestCoinsFormControllerProvider.select((state) => state.network),
    );

    return AddressNotFoundModal(
      network: selectedNetwork,
      onWalletCreated: (_) {
        onWalletCreated(ref.context);
      },
    );
  }
}
