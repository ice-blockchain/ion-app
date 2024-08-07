import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/address_input_field.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/contact_button.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/providers/contacts_provider.dart';

class ContactInputSwitcher extends ConsumerWidget {
  const ContactInputSwitcher({
    required this.contactId,
    required this.onContactPressed,
    required this.onClear,
    super.key,
  });

  final String? contactId;
  final VoidCallback onContactPressed;
  final ValueChanged<String?> onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (contactId == null) {
      return AddressInputField(
        onOpenContactList: onContactPressed,
        onScanPressed: () {},
      );
    }

    final contact = ref.watch(contactByIdProvider(id: contactId!));

    return ContactButton(
      contact: contact,
      onContactTap: onContactPressed,
      onClearContact: () => onClear(null),
    );
  }
}
