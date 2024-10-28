// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/wallet/views/pages/wallet_page/components/contacts/providers/contacts_provider.dart';
import 'package:ion/generated/assets.gen.dart';

class StoryShareContactList extends ConsumerWidget {
  const StoryShareContactList({
    required this.selectedContacts,
    required this.toggleContactSelection,
    super.key,
  });

  final List<String> selectedContacts;
  final void Function(String) toggleContactSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);

    return ListView.builder(
      padding: EdgeInsets.only(top: 8.0.s),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final isSelected = selectedContacts.contains(contact.id);

        return ScreenSideOffset.small(
          child: Padding(
            padding: EdgeInsets.only(bottom: 12.0.s),
            child: ListItem.user(
              title: Text(contact.name),
              subtitle: Text(contact.nickname!),
              profilePicture: contact.icon,
              verifiedBadge: contact.isVerified!,
              iceBadge: contact.hasIceAccount,
              onTap: () => toggleContactSelection(contact.id),
              trailing: isSelected
                  ? Assets.svg.iconBlockCheckboxOn.icon()
                  : Assets.svg.iconBlockCheckboxOff.icon(),
            ),
          ),
        );
      },
    );
  }
}
