// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/address_input_field.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/contact_button.dart';

class ContactInputSwitcher extends ConsumerWidget {
  const ContactInputSwitcher({
    required this.pubkey,
    required this.address,
    required this.onContactTap,
    required this.onClearTap,
    required this.onWalletAddressChanged,
    required this.onScanPressed,
    super.key,
  });

  final String? pubkey;
  final String? address;
  final VoidCallback onContactTap;
  final ValueChanged<String?> onClearTap;
  final ValueChanged<String?> onWalletAddressChanged;
  final VoidCallback onScanPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pubkey == null) {
      return AddressInputField(
        initialValue: address,
        onOpenContactList: onContactTap,
        onAddressChanged: onWalletAddressChanged,
        onScanPressed: onScanPressed,
      );
    }

    final userMetadata = ref.watch(userMetadataProvider(pubkey!)).valueOrNull;

    if (userMetadata == null) {
      return const SizedBox.shrink();
    }

    return ContactButton(
      userMetadata: userMetadata.data,
      onContactTap: onContactTap,
      onClearTap: () => onClearTap(null),
    );
  }
}
