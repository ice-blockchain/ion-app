import 'package:flutter/material.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';

class PostList extends StatelessWidget {
  const PostList({
    required this.posts,
    this.separator,
    super.key,
  });

  final List<PostData> posts;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: posts.length,
      separatorBuilder: (BuildContext context, int index) {
        return separator ?? FeedListSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        return Post(postData: posts[index]);
      },
    );
  }
}
