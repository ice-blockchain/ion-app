import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/template/ice_page.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/model/contact_data.dart';
import 'package:ice/app/features/wallet/providers/mock_data/contacts_mock_data.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';

class ContactsListView extends IceSimplePage {
  const ContactsListView(
    super.key,
    super.payload,
  );

  @override
  Widget buildPage(BuildContext context, WidgetRef ref, __) {
    final List<ContactData> contacts = mockedContactDataArray;

    return FractionallySizedBox(
      heightFactor: 0.79,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: context.i18n.wallet_send_coins,
              showBackButton: false,
              actions: const <Widget>[
                NavigationCloseButton(),
              ],
            ),
          ),
          ScreenSideOffset.small(
            child: SearchInput(
              onTextChanged: (String value) {},
            ),
          ),
          SizedBox(
            height: 12.0.s,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: contacts.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 12.0.s,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                final ContactData contact = contacts[index];

                return ScreenSideOffset.small(
                  child: ListItem.user(
                    title: Text(contact.name),
                    subtitle: Text(contact.nickname!),
                    profilePicture: contact.icon,
                    verifiedBadge: contact.isVerified!,
                    iceBadge: contact.hasIceAccount,
                    timeago: contact.lastSeen,
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
