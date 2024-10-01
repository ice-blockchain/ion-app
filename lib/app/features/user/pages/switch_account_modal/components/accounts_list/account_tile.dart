// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/skeleton/skeleton.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/auth/providers/auth_provider.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';

class AccountsTile extends ConsumerWidget {
  const AccountsTile({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(currentUserIdSelectorProvider);
    final userDataValue = ref.watch(userDataProvider(userId)).valueOrNull;
    final isCurrentUser = userId == currentUserId;

    if (userDataValue == null) {
      return Skeleton(child: ListItem());
    }

    return ListItem.user(
      isSelected: isCurrentUser,
      onTap: () {
        if (!isCurrentUser) {
          ref.read(authProvider.notifier).setCurrentUser(userId);
        }
      },
      title: Text(
        userDataValue.displayName ?? userDataValue.name,
      ),
      subtitle: Text(
        prefixUsername(username: userDataValue.name, context: context),
      ),
      profilePicture: userDataValue.picture,
      trailing: isCurrentUser == true
          ? Assets.svg.iconBlockCheckboxOnblue.icon(color: context.theme.appColors.onPrimaryAccent)
          : null,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s),
      backgroundColor: context.theme.appColors.tertararyBackground,
      borderRadius: ListItem.defaultBorderRadius,
      constraints: ListItem.defaultConstraints,
    );
  }
}
