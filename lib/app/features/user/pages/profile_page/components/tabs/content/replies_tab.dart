// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/views/components/post_list/components/post_list_item.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content_separator.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';

class RepliesTab extends StatelessWidget {
  const RepliesTab({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  static const UserContentType tabType = UserContentType.replies;

  @override
  Widget build(BuildContext context) {
    const replies = <PostEntity>[];

    if (replies.isEmpty) {
      return const EmptyState(
        tabType: tabType,
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) {
        return ColoredBox(
          color: context.theme.appColors.secondaryBackground,
          child: PostListItem(
            post: replies[index],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const ContentSeparator();
      },
      itemCount: replies.length,
    );
  }
}
