import 'package:flutter/material.dart';
import 'package:ice/app/components/button/button.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/build_context.dart';
import 'package:ice/app/extensions/num.dart';
import 'package:ice/app/extensions/theme_data.dart';
import 'package:ice/app/features/auth/views/pages/discover_creators/mocked_creators.dart';

class CreatorListItem extends StatelessWidget {
  const CreatorListItem({
    required this.creator,
    required this.followed,
    required this.onPressed,
    super.key,
  });

  final User creator;

  final bool followed;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: ListItem.user(
        title: Text(creator.name),
        subtitle: Text(creator.nickname),
        profilePicture: creator.imageUrl,
        verifiedBadge: creator.isVerified ?? false,
        backgroundColor: context.theme.appColors.tertararyBackground,
        contentPadding: EdgeInsets.all(12.0.s),
        borderRadius: BorderRadius.circular(16.0.s),
        trailing: Button(
          onPressed: onPressed,
          type: followed ? ButtonType.primary : ButtonType.outlined,
          tintColor: followed ? null : context.theme.appColors.primaryAccent,
          label: Text(
            followed
                ? context.i18n.button_following
                : context.i18n.button_follow,
            style: context.theme.appTextThemes.caption.copyWith(
              color: followed
                  ? context.theme.appColors.secondaryBackground
                  : context.theme.appColors.primaryAccent,
            ),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: Size(77.0.s, 28.0.s),
            padding: EdgeInsets.symmetric(horizontal: 5.0.s),
          ),
        ),
        trailingPadding: EdgeInsets.only(left: 6.0.s),
      ),
    );
  }
}
