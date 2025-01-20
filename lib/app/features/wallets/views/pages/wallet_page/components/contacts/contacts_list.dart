// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallets/providers/contacts_data_provider.c.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/contacts/contacts_list_header.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/contacts/contacts_list_item.dart';
import 'package:ion/app/features/wallets/views/pages/wallet_page/components/contacts/contacts_list_loader.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsDataAsyncValue = ref.watch(contactsDataNotifierProvider);

    final footer = SizedBox(
      height: ScreenSideOffset.defaultSmallMargin,
    );

    return contactsDataAsyncValue.maybeWhen(
      data: (contactsData) {
        final contactsDataArray = contactsData.values.toList();
        return Column(
          children: [
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
                  final contactData = contactsDataArray[index];
                  return ContactsListItem(
                    onTap: () => ContactRoute(contactId: contactData.id).push<void>(context),
                    imageUrl: contactData.icon,
                    label: contactData.nickname != null
                        ? prefixUsername(
                            username: contactData.nickname,
                            context: context,
                          )
                        : contactData.phoneNumber ?? '',
                    hasIceAccount: contactData.hasIceAccount,
                  );
                },
              ),
            ),
            footer,
          ],
        );
      },
      orElse: () => ContactsListLoader(footer: footer),
    );
  }
}
