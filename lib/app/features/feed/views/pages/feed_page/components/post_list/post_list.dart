import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/model/post_data.dart';
import 'package:ice/app/features/feed/providers/feed_provider.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/post_list/components/post_list.dart';
import 'package:ice/app/features/feed/views/pages/feed_page/components/post_list/components/post_list_skeleton.dart';

class Posts extends HookConsumerWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostData>> posts = ref.watch(feedNotifierProvider);

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ref.read(feedNotifierProvider.notifier).fetchPosts(),
        );
        return null;
      },
      <Object?>[],
    );

    return posts.maybeWhen(
      data: (List<PostData> data) => PostList(
        posts: data,
      ),
      orElse: () => const PostListSkeleton(),
    );
  }
}
