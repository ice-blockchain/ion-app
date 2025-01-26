// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/contacts/providers/contact_by_pubkey_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/address_input_field.dart';
import 'package:ion/app/features/wallets/views/pages/coins_flow/send_coins/components/buttons/contact_button.dart';
import 'package:ion/app/router/app_routes.c.dart';

class ContactInputSwitcher extends ConsumerWidget {
  const ContactInputSwitcher({
    required this.pubkey,
    required this.onContactTap,
    required this.onClearTap,
    super.key,
  });

  final String? pubkey;
  final VoidCallback onContactTap;
  final ValueChanged<String?> onClearTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (pubkey == null) {
      return AddressInputField(
        onOpenContactList: onContactTap,
        onScanPressed: () => CoinSendScanRoute().push<void>(context),
      );
    }

    final contact = ref.watch(contactByPubkeyProvider(pubkey!)).valueOrNull;

    if (contact == null) {
      return const SizedBox.shrink();
    }

    return ContactButton(
      contact: contact,
      onContactTap: onContactTap,
      onClearTap: () => onClearTap(null),
    );
  }
}
