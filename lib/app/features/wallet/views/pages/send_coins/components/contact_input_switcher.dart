import 'package:flutter/material.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/address_input_field.dart';
import 'package:ice/app/features/wallet/views/pages/send_coins/components/buttons/contact_button.dart';
import 'package:ice/app/router/app_routes.dart';

class ContactInputSwitcher extends StatelessWidget {
  const ContactInputSwitcher({
    required this.selectedContact,
    required this.onContactSelected,
  });

  final ContactData? selectedContact;
  final Function(ContactData?) onContactSelected;

  @override
  Widget build(BuildContext context) {
    return selectedContact != null
        ? ContactButton(
            contact: selectedContact!,
            onContactTap: () async => await selectContact(context),
            onClearContact: () => onContactSelected(null),
          )
        : AddressInputField(
            onOpenContactList: () async => await selectContact(context),
            onScanPressed: () {},
          );
  }

  Future<void> selectContact(BuildContext context) async {
    final ContactData? contact =
        await IceRoutes.contactsSelect.push<ContactData>(context);

    if (!context.mounted) return;

    onContactSelected(contact);
  }
}
