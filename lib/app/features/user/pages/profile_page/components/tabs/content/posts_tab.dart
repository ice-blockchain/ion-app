// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/views/components/post_list/components/post_list_item.dart';
import 'package:ion/app/features/user/model/user_content_type.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/content_separator.dart';
import 'package:ion/app/features/user/pages/profile_page/components/tabs/empty_state.dart';

class PostsTab extends StatelessWidget {
  const PostsTab({
    required this.pubkey,
    super.key,
  });

  final String pubkey;

  static const UserContentType tabType = UserContentType.posts;

  @override
  Widget build(BuildContext context) {
    const posts = <String>[];

    if (posts.isEmpty) {
      return const EmptyState(
        tabType: tabType,
      );
    }

    return SliverList.separated(
      itemCount: posts.length,
      separatorBuilder: (BuildContext context, int index) {
        return const ContentSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        return ColoredBox(
          color: context.theme.appColors.secondaryBackground,
          child: PostListItem(
            postId: posts[index],
          ),
        );
      },
    );
  }
}
