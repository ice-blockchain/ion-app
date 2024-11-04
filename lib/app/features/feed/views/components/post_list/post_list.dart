// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/features/feed/data/models/post/post_data.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post_list/components/post_list_item.dart';
import 'package:ion/app/features/nostr/model/nostr_entity.dart';

class PostList extends StatelessWidget {
  const PostList({
    required this.posts,
    this.separator,
    super.key,
  });

  final List<NostrEntity> posts;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: posts.length,
      separatorBuilder: (BuildContext context, int index) {
        return separator ?? FeedListSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        final post = posts[index];
        if (post is PostEntity) {
          return PostListItem(post: post);
        }
        return null;
      },
    );
  }
}
