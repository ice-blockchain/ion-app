import 'package:flutter/material.dart';
import 'package:ice/app/components/list_item/list_item.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/components/follow_user_button/follow_user_button.dart';
import 'package:ice/app/features/feed/feed_search/model/feed_search_user.dart';

class FeedAdvancedSearchUserListItem extends StatelessWidget {
  const FeedAdvancedSearchUserListItem({
    super.key,
    required this.user,
  });

  final FeedSearchUser user;

  @override
  Widget build(BuildContext context) {
    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.0.s),
          ListItem.user(
            title: Text(user.name),
            subtitle: Text(user.nickname),
            ntfAvatar: user.nft,
            profilePicture: user.imageUrl,
            verifiedBadge: user.isVerified,
            trailing: FollowUserButton(userId: user.id),
          ),
          SizedBox(height: 10.0.s),
          Text(
            'Bitcoin Investor & Entepreneur. Faunder of WealthMastery.',
            style: context.theme.appTextThemes.body2.copyWith(
              color: context.theme.appColors.sharkText,
            ),
          ),
          SizedBox(height: 12.0.s),
        ],
      ),
    );
  }
}
