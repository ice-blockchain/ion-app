// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/contacts/providers/contacts_provider.dart';
import 'package:ion/app/router/app_routes.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

enum ContactRouteAction {
  navigate,
  pop,
}

class ContactsListView extends ConsumerWidget {
  const ContactsListView({
    required this.appBarTitle,
    required this.action,
    super.key,
  });

  final String appBarTitle;
  final ContactRouteAction action;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contacts = ref.watch(contactsProvider);

    return SheetContent(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            primary: false,
            flexibleSpace: NavigationAppBar.modal(
              showBackButton: false,
              actions: [
                NavigationCloseButton(
                  onPressed: () => context.pop(),
                ),
              ],
              title: Text(appBarTitle),
            ),
            automaticallyImplyLeading: false,
            toolbarHeight: NavigationAppBar.modalHeaderHeight,
            pinned: true,
          ),
          PinnedHeaderSliver(
            child: ColoredBox(
              color: context.theme.appColors.onPrimaryAccent,
              child: Column(
                children: [
                  SizedBox(height: 16.0.s),
                  ScreenSideOffset.small(
                    child: SearchInput(
                      onTextChanged: (String value) {},
                    ),
                  ),
                  SizedBox(height: 16.0.s),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final contact = contacts[index];
                return ScreenSideOffset.small(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0.s),
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
                  ),
                );
              },
              childCount: contacts.length,
            ),
          ),
        ],
      ),
    );
  }
}
