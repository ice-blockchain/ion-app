// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/user/follow_user_button/follow_user_button.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';

class FeedAdvancedSearchUserListItem extends ConsumerWidget {
  const FeedAdvancedSearchUserListItem({
    required this.user,
    super.key,
  });

  final UserMetadataEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserMetadata(:about, :displayName, :name, :picture) = user.data;

    return GestureDetector(
      onTap: () => ProfileRoute(pubkey: user.masterPubkey).push<void>(context),
      child: ScreenSideOffset.small(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12.0.s),
            ListItem.user(
              title: Text(displayName),
              subtitle: Text(
                prefixUsername(username: name, context: context),
              ),
              profilePicture: picture,
              trailing: FollowUserButton(pubkey: user.masterPubkey),
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
      ),
    );
  }
}
