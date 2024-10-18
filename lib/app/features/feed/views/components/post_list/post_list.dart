// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post_list/components/post_list_item.dart';

class PostList extends StatelessWidget {
  const PostList({
    required this.postIds,
    this.separator,
    super.key,
  });

  final List<String> postIds;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: postIds.length,
      separatorBuilder: (BuildContext context, int index) {
        return separator ?? FeedListSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        return PostListItem(postId: postIds[index]);
      },
    );
  }
}
