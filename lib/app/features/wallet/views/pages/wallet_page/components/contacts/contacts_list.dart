// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/container_skeleton.dart';
import 'package:ion/app/extensions/num.dart';
import 'package:ion/app/features/wallet/providers/contacts_data_provider.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list_header.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/contacts/contacts_list_item.dart';
import 'package:ion/app/router/app_routes.dart';
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
        // Use contactsDataArray as needed
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
      orElse: () => Column(
        children: [
          ContainerSkeleton(
            width: MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2,
            height: 16.0.s,
            margin: EdgeInsets.symmetric(vertical: 16.0.s),
          ),
          SizedBox(
            height: ContactsListItem.height,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: ScreenSideOffset.defaultSmallMargin,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(width: 12.0.s);
              },
              itemBuilder: (BuildContext context, int index) {
                final size = 54.0.s;
                return ContainerSkeleton(
                  width: size,
                  height: size,
                  margin: EdgeInsets.symmetric(
                    vertical: (ContactsListItem.height - size) / 2,
                    horizontal: (ContactsListItem.width - size) / 2,
                  ),
                );
              },
            ),
          ),
          footer,
        ],
      ),
    );
  }
}
