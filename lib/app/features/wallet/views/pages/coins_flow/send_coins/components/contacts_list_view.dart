import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/inputs/search_input/search_input.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/wallet/views/pages/wallet_page/components/contacts/providers/contacts_provider.dart';
import 'package:ice/app/router/app_routes.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ice/app/router/components/sheet_content/sheet_content.dart';

enum ContactRouteAction {
  navigate,
  pop,
}

class ContactsListView extends ConsumerWidget {
  const ContactsListView({
    super.key,
    required this.appBarTitle,
    required this.action,
  });

  final String appBarTitle;
  final ContactRouteAction action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);

    return SheetContent(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0.s),
            child: NavigationAppBar.screen(
              title: Text(appBarTitle),
              showBackButton: false,
              actions: [
                NavigationCloseButton(
                  onPressed: () {
                    context.pop();
                  },
                ),
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
          ListView.separated(
            shrinkWrap: true,
            itemCount: contacts.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 12.0.s,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final contact = contacts[index];

              return ScreenSideOffset.small(
                child: ListItem.user(
                  title: Text(contact.name),
                  subtitle: Text(contact.nickname!),
                  profilePicture: contact.icon,
                  verifiedBadge: contact.isVerified!,
                  iceBadge: contact.hasIceAccount,
                  timeago: contact.lastSeen,
                  onTap: () => action == ContactRouteAction.pop
                      ? context.pop(contact.id)
                      : ContactRoute(contactId: contact.id).push<void>(context),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
