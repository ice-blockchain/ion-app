import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/list_separator/list_separator.dart';

class PostList extends HookConsumerWidget {
  const PostList({
    required this.posts,
    this.separatorHeight,
    super.key,
  });

  final List<PostData> posts;
  final double? separatorHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.separated(
      itemCount: posts.length,
      separatorBuilder: (BuildContext context, int index) {
        return FeedListSeparator(height: separatorHeight);
      },
      itemBuilder: (BuildContext context, int index) {
        return Post(postData: posts[index]);
      },
    );
  }
}
