import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';

class AccountsTile extends ConsumerWidget {
  const AccountsTile({
    required this.userData,
    super.key,
  });

  final UserData userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeUser = ref.watch(userDataNotifierProvider);
    final isActiveUser = userData.id == activeUser.id;
    return Padding(
      padding: EdgeInsets.only(top: 16.0.s),
      child: ListItem.user(
        isSelected: isActiveUser,
        onTap: () {
          if (!isActiveUser) {
            ref.read(userDataNotifierProvider.notifier).userData = userData;
          }
        },
        title: Text(
          userData.name,
          style: context.theme.appTextThemes.subtitle3,
        ),
        subtitle: Text(
          prefixUsername(
            username: userData.nickname,
            context: context,
          ),
          style: context.theme.appTextThemes.caption,
        ),
        profilePicture: userData.profilePicture,
        verifiedBadge: userData.isVerified ?? false,
        trailing: isActiveUser == true
            ? Assets.images.icons.iconBlockCheckboxOn
                .icon(color: context.theme.appColors.onPrimaryAccent)
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0.s),
        backgroundColor: context.theme.appColors.tertararyBackground,
        borderRadius: ListItem.defaultBorderRadius,
        constraints: ListItem.defaultConstraints,
      ),
    );
  }
}
