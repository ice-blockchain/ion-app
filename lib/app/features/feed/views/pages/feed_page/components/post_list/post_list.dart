import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/providers/feed_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/post_list/components/post_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/post_list/components/post_list_skeleton.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class Posts extends HookConsumerWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(feedNotifierProvider);

    useOnInit<void>(() {
      ref.read(feedNotifierProvider.notifier).fetchPosts();
    });

    return posts.maybeWhen(
      data: (List<PostData> data) => PostList(
        posts: data,
      ),
      orElse: () => const PostListSkeleton(),
    );
  }
}
