import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/providers/posts_provider.dart';
import 'package:ice/app/features/feed/views/components/post_list/components/post_list_skeleton.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class FeedPosts extends HookConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(feedCurrentFilterProvider).category;
    final postIds = ref.watch(categoryPostIdsProvider(category: category));

    useOnInit(() {
      ref.read(postsProvider.notifier).fetchCategoryPosts(category: category);
    }, [category]);

    if (postIds.isEmpty) {
      return const PostListSkeleton();
    }

    return PostList(postIds: postIds);
  }
}
