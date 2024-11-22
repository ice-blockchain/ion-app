// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/groups/model/alphabetical_list_item.dart';
import 'package:ion/generated/assets.gen.dart';

class AlphabeticalListItemWidget extends StatelessWidget {
  const AlphabeticalListItemWidget({
    required this.item,
    required this.onUserItemTap,
    required this.isUserSelected,
    super.key,
  });

  final AlphabeticalListItem item;
  final void Function(UserItem) onUserItemTap;
  final bool Function(UserItem) isUserSelected;

  @override
  Widget build(BuildContext context) => item.map(
        user: (item) => ListItem(
          contentPadding: EdgeInsets.zero,
          constraints: BoxConstraints(maxHeight: 36.0.s),
          backgroundColor: context.theme.appColors.secondaryBackground,
          onTap: () => onUserItemTap(item),
          title: Text(item.user.name),
          subtitle: Text(item.user.username),
          leading: Avatar(imageUrl: item.user.avatarUrl, size: 30.0.s),
          trailing: isUserSelected(item)
              ? Assets.svg.iconBlockCheckboxOn.icon()
              : Assets.svg.iconBlockCheckboxOff.icon(),
        ),
        header: (item) => Text(
          item.title,
          style: context.theme.appTextThemes.caption3.copyWith(
            color: context.theme.appColors.primaryText,
          ),
        ),
      );
}
