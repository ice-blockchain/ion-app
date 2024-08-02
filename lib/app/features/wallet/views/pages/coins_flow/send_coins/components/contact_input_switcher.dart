import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/address_input_field.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/contact_button.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/providers/contacts_provider.dart';
import 'package:ice/app/router/app_routes.dart';

class ContactInputSwitcher extends ConsumerWidget {
  const ContactInputSwitcher({
    required this.selectedContactId,
    required this.onContactSelected,
    super.key,
  });

  final String? selectedContactId;
  final void Function(String?) onContactSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedContactId != null) {
      final contact = ref.watch(contactByIdProvider(id: selectedContactId!));

      return ContactButton(
        contact: contact,
        onContactTap: () => selectContact(context),
        onClearContact: () => onContactSelected(null),
      );
    } else {
      return AddressInputField(
        onOpenContactList: () => selectContact(context),
        onScanPressed: () {},
      );
    }
  }

  Future<void> selectContact(BuildContext context) async {
    final contactId = await ContactsListRoute(
      title: context.i18n.contacts_select_title,
    ).push<String>(context);

    if (!context.mounted) return;

    onContactSelected(contactId);
  }
}
