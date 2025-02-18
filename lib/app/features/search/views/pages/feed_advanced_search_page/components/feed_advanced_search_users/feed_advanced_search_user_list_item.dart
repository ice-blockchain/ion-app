// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/user/follow_user_button/follow_user_button.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/user/providers/user_metadata_provider.c.dart';
import 'package:ion/app/utils/username.dart';

class FeedAdvancedSearchUserListItem extends ConsumerWidget {
  const FeedAdvancedSearchUserListItem({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMetadataValue = ref.watch(userMetadataProvider(pubkey)).valueOrNull?.data;

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
            profilePicture: userMetadataValue.picture,
            trailing: FollowUserButton(pubkey: pubkey),
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
