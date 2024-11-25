// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/avatar/avatar.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/chat/groups/model/user.dart';
import 'package:ion/app/features/chat/groups/providers/create_group_form_controller_provider.dart';
import 'package:ion/app/utils/username.dart';
import 'package:ion/generated/assets.gen.dart';

class GroupMemberListItem extends ConsumerWidget {
  const GroupMemberListItem({required this.member, super.key});

  final User member;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListItem(
      contentPadding: EdgeInsets.zero,
      constraints: BoxConstraints(maxHeight: 36.0.s),
      backgroundColor: context.theme.appColors.secondaryBackground,
      title: Text(member.name),
      subtitle: Text(
        prefixUsername(
          context: context,
          username: member.username,
        ),
      ),
      leading: Avatar(
        imageUrl: member.avatarUrl,
        size: 30.0.s,
      ),
      trailing: GestureDetector(
        onTap: () {
          ref
              .read(
                createGroupFormControllerProvider.notifier,
              )
              .toggleMember(member);
        },
        child: Assets.svg.iconBlockDelete.icon(
          size: 24.0.s,
          color: context.theme.appColors.sheetLine,
        ),
      ),
    );
  }
}
