import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/constants/ui_size.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/username.dart';
import 'package:ice/generated/assets.gen.dart';

class AccountsTile extends HookConsumerWidget {
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
      padding: EdgeInsets.symmetric(vertical: UiSize.small),
      child: ListItem.user(
        isSelected: isActiveUser,
        onTap: () {
          if (!isActiveUser) {
            ref.read(userDataNotifierProvider.notifier).userData = userData;
          }
        },
        title: Text(
          userData.name,
        ),
        subtitle: Text(
          prefixUsername(
            username: userData.nickname,
            context: context,
          ),
        ),
        profilePicture: userData.profilePicture,
        verifiedBadge: userData.isVerified ?? false,
        trailing: isActiveUser == true
            ? Assets.images.icons.iconCheckboxOn
                .icon(color: context.theme.appColors.onPrimaryAccent)
            : null,
        contentPadding: EdgeInsets.symmetric(horizontal: UiSize.medium),
        backgroundColor: context.theme.appColors.tertararyBackground,
        borderRadius: ListItem.defaultBorderRadius,
        constraints: ListItem.defaultConstraints,
      ),
    );
  }
}
