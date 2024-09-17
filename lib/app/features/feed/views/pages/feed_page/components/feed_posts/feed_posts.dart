import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/feed_category_post_ids.dart';
import 'package:ice/app/features/feed/providers/feed_current_filter_provider.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list_skeleton.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class FeedPosts extends HookConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(feedCurrentFilterProvider.select((state) => state.category));
    final postIds = ref.watch(feedCategoryPostIdsProvider(category: category));

    useOnInit(() {
      ref.read(feedCategoryPostIdsProvider(category: category).notifier).fetchPosts();
    }, [category]);

    if (postIds.isEmpty) {
      return const PostListSkeleton();
    }

    return PostList(postIds: postIds);
  }
}
