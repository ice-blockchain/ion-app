// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/address_input_field.dart';
import 'package:ion/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/contact_button.dart';

class ContactInputSwitcher extends ConsumerWidget {
  const ContactInputSwitcher({
    required this.contactId,
    required this.onContactTap,
    required this.onClearTap,
    super.key,
  });

  final String? contactId;
  final VoidCallback onContactTap;
  final ValueChanged<String?> onClearTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (contactId == null) {
      return AddressInputField(
        onOpenContactList: onContactTap,
        onScanPressed: () {},
      );
    }

    final contact = ref.watch(contactByIdProvider(id: contactId!));

    return ContactButton(
      contact: contact,
      onContactTap: onContactTap,
      onClearTap: () => onClearTap(null),
    );
  }
}
