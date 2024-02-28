import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/extensions/asset_gen_image.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/user/model/user_data.dart';
import 'package:ice/app/features/user/providers/user_data_provider.dart';
import 'package:ice/app/utils/image.dart';
import 'package:ice/generated/assets.gen.dart';

class AccountsTile extends HookConsumerWidget {
  const AccountsTile({
    super.key,
    required this.userData,
  });

  final UserData userData;

  double get avatarSize => 30.0.s;

  double get verifiedIconSize => 16.0.s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserData activeUser = ref.watch(userDataNotifierProvider);
    final bool isActiveUser = userData.id == activeUser.id;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.s),
      child: ListItem(
        onTap: () {
          if (!isActiveUser) {
            ref.read(userDataNotifierProvider.notifier).userData = userData;
          }
        },
        backgroundColor: isActiveUser
            ? context.theme.appColors.primaryAccent
            : context.theme.appColors.tertararyBackground,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10.0.s),
          child: CachedNetworkImage(
            imageUrl:
                getAdaptiveImageUrl(userData.profilePicture, avatarSize * 2),
            width: avatarSize,
            height: avatarSize,
            fit: BoxFit.fitWidth,
          ),
        ),
        title: Row(
          children: <Widget>[
            Text(
              userData.name,
              style: context.theme.appTextThemes.subtitle3.copyWith(
                color: isActiveUser
                    ? context.theme.appColors.onPrimaryAccent
                    : context.theme.appColors.primaryText,
              ),
            ),
            if (userData.isVerified == true) ...<Widget>[
              SizedBox(width: 4.0.s),
              Assets.images.icons.iconBadgeVerify
                  .image(width: verifiedIconSize, height: verifiedIconSize),
            ],
          ],
        ),
        subtitle: Text(
          '@${userData.nickname}',
          style: context.theme.appTextThemes.caption.copyWith(
            color: isActiveUser
                ? context.theme.appColors.onPrimaryAccent
                : context.theme.appColors.tertararyText,
          ),
        ),
        trailing: isActiveUser == true
            ? Assets.images.icons.iconCheckboxOn
                .icon(color: context.theme.appColors.onPrimaryAccent)
            : null,
      ),
    );
  }
}
