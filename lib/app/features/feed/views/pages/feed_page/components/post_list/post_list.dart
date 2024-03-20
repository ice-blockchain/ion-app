import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/components/post/post.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/providers/feed_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/list_separator/list_separator.dart';

class PostList extends HookConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PostData> posts = ref.watch(feedProvider);

    useEffect(
      () {
        ref.read(feedProvider.notifier).fetchPosts();
        return null;
      },
      <Object?>[],
    );

    return SliverList.separated(
      itemCount: posts.length,
      separatorBuilder: (BuildContext context, int index) {
        return FeedListSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        return Post(
          content: posts[index].body,
        );
      },
    );
  }
}
