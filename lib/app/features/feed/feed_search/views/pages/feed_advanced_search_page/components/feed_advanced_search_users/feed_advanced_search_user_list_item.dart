// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/button/follow_user_button.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.dart';
import 'package:ion/app/utils/username.dart';

class FeedAdvancedSearchUserListItem extends ConsumerWidget {
  const FeedAdvancedSearchUserListItem({
    required this.userId,
    super.key,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataValue = ref.watch(userMetadataProvider(userId)).valueOrNull;

    if (userMetadataValue == null) {
      return ScreenSideOffset.small(child: const Skeleton(child: PostSkeleton()));
    }

    final about = userMetadataValue.about;

    return ScreenSideOffset.small(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.0.s),
          ListItem.user(
            title: Text(userMetadataValue.displayName),
            subtitle: Text(
              prefixUsername(username: userMetadataValue.name, context: context),
            ),
            ntfAvatar: userMetadataValue.nft,
            profilePicture: userMetadataValue.picture,
            verifiedBadge: userMetadataValue.verified,
            trailing: FollowUserButton(onPressed: () {}, following: false),
          ),
          if (about != null) ...[
            SizedBox(height: 10.0.s),
            Text(
              about,
              style: context.theme.appTextThemes.body2.copyWith(
                color: context.theme.appColors.sharkText,
              ),
            ),
          ],
          SizedBox(height: 12.0.s),
        ],
      ),
    );
  }
}
