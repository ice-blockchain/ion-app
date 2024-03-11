import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/providers/contacts_data_provider.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list_header.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list_item.dart';

class ContactsList extends HookConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Map<String, ContactData> contactsData =
        ref.watch(contactsDataNotifierProvider);
    final List<ContactData> contactsDataArray = contactsData.values.toList();

    if (contactsDataArray.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: <Widget>[
        const ContactListHeader(),
        SizedBox(
          height: ContactsListItem.height,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSideOffset.defaultSmallMargin,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: contactsDataArray.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(width: 12.0.s);
            },
            itemBuilder: (BuildContext context, int index) {
              final ContactData contactData = contactsDataArray[index];
              return ContactsListItem(
                imageUrl: contactData.icon,
                label: contactData.nickname != null
                    ? '@${contactData.nickname}'
                    : contactData.phoneNumber ?? '',
                hasIceAccount: contactData.hasIceAccount,
              );
            },
          ),
        ),
        SizedBox(
          height: ScreenSideOffset.defaultSmallMargin,
        ),
      ],
    );
  }
}
