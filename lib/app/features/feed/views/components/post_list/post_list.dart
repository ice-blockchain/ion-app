import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/feed_current_category_provider.dart';
import 'package:ice/app/features/feed/providers/posts_provider.dart';
import 'package:ice/app/features/feed/views/components/post_list/components/post_list.dart';
import 'package:ice/app/features/feed/views/components/post_list/components/post_list_skeleton.dart';

class Posts extends HookConsumerWidget {
  const Posts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(feedCurrentCategoryProvider);
    final postIds = ref.watch(categoryPostIdsProvider(category: category));

    useEffect(() {
      ref.read(postsProvider.notifier).fetchCategoryPosts(category: category);
      return null;
    }, [category]);

    if (postIds.isEmpty) {
      return const PostListSkeleton();
    }

    return PostList(postIds: postIds);
  }
}
