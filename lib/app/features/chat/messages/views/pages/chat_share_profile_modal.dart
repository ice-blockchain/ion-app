// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ion/app/components/inputs/search_input/search_input.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_close_button.dart';
import 'package:ion/app/router/components/sheet_content/sheet_content.dart';

class ChatShareProfileModal extends StatelessWidget {
  const ChatShareProfileModal({super.key});

  @override
  Widget build(BuildContext context) {
    return SheetContent(
      topPadding: 0,
      body: Column(
        children: [
          NavigationAppBar.modal(
            showBackButton: false,
            title: Text(context.i18n.chat_profile_share_modal_title),
            actions: [NavigationCloseButton(onPressed: () => context.pop())],
          ),
          SizedBox(height: 9.0.s),
          Expanded(
            child: ScreenSideOffset.small(
              child: Column(
                children: [
                  const SearchInput(
                    textInputAction: TextInputAction.search,
                  ),
                  SizedBox(height: 14.0.s),
                  const Expanded(
                    child: _ProfileList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileList extends StatelessWidget {
  const _ProfileList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return ListItem.user(
          title: const Text('Arnold Grey'),
          subtitle: const Text('@arnoldgrey'),
          profilePicture: 'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
          verifiedBadge: true,
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10.0.s);
      },
      itemCount: 20,
    );
  }
}
