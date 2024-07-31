import 'package:flutter/material.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/address_input_field.dart';
import 'package:ice/app/features/wallet/views/pages/coins_flow/send_coins/components/buttons/contact_button.dart';
import 'package:ice/app/router/app_routes.dart';

class ContactInputSwitcher extends StatelessWidget {
  const ContactInputSwitcher({
    required this.selectedContact,
    required this.onContactSelected,
    super.key,
  });

  final ContactData? selectedContact;
  final void Function(ContactData?) onContactSelected;

  @override
  Widget build(BuildContext context) {
    return selectedContact != null
        ? ContactButton(
            contact: selectedContact!,
            onContactTap: () => selectContact(context),
            onClearContact: () => onContactSelected(null),
          )
        : AddressInputField(
            onOpenContactList: () => selectContact(context),
            onScanPressed: () {},
          );
  }

  Future<void> selectContact(BuildContext context) async {
    final contact = await ContactsSelectRoute(
      title: context.i18n.contacts_select_title,
    ).push<ContactData>(context);

    if (!context.mounted) return;

    onContactSelected(contact);
  }
}
