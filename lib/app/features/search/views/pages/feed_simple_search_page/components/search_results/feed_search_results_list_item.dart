// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/list_item/list_item.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/search/providers/feed_search_history_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/app/router/app_routes.c.dart';
import 'package:ion/app/utils/username.dart';

class FeedSearchResultsListItem extends ConsumerWidget {
  const FeedSearchResultsListItem({required this.user, super.key});

  static double get itemVerticalOffset => 8.0.s;

  final UserMetadataEntity user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: itemVerticalOffset),
      child: ScreenSideOffset.small(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            ref.read(feedSearchHistoryProvider.notifier).addUserIdToTheHistory(user.masterPubkey);
            ProfileRoute(pubkey: user.masterPubkey).push<void>(context);
          },
          child: ListItem.user(
            title: Text(user.data.displayName),
            subtitle: Text(
              prefixUsername(username: user.data.name, context: context),
            ),
            profilePicture: user.data.picture,
          ),
        ),
      ),
    );
  }
}
