// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/generated/assets.gen.dart';

class ShareUserList extends StatelessWidget {
  const ShareUserList({
    required this.users,
    required this.selectedUserIds,
    required this.onUserPressed,
    super.key,
  });

  final List<int> users;

  final Set<int> selectedUserIds;

  final void Function(int) onUserPressed;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onUserPressed(users[index]),
          child: ScreenSideOffset.small(
            child: ListItem.user(
              title: const Text('Arnold Grey'),
              subtitle: const Text('@arnoldgrey'),
              profilePicture:
                  'https://ice-staging.b-cdn.net/profile/default-profile-picture-16.png',
              trailing: selectedUserIds.contains(users[index])
                  ? Assets.svg.iconBlockCheckboxOn.icon()
                  : Assets.svg.iconBlockCheckboxOff
                      .icon(color: context.theme.appColors.onTerararyFill),
              contentPadding: EdgeInsets.symmetric(vertical: 8.0.s),
            ),
          ),
        );
      },
      padding: EdgeInsets.only(bottom: 8.0.s),
    );
  }
}
