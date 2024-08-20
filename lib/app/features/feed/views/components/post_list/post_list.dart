import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/feed/feed_provider.dart';
import 'package:ice/app/features/feed/views/components/post_list/components/post_list.dart';
import 'package:ice/app/features/feed/views/components/post_list/components/post_list_skeleton.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class Posts extends HookConsumerWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedCurrentCategoryPostsProvider);

    useOnInit<void>(() {
      ref.read(feedPostsProvider.notifier).fetchPosts();
    });

    print('posts $posts');

    if (posts.isEmpty) {
      return const PostListSkeleton();
    }

    return PostList(posts: posts);
  }
}
