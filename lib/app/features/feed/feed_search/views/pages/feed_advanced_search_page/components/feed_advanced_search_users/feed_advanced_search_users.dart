import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_users_provider.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list_skeleton.dart';

class FeedAdvancedSearchUsers extends ConsumerWidget {
  const FeedAdvancedSearchUsers({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersSearchResults = ref.watch(feedSearchUsersProvider(query));
    return CustomScrollView(
      slivers: [
        usersSearchResults.maybeWhen(
          data: (data) {
            return PostList(postIds: []);
          },
          orElse: () => PostListSkeleton(),
        )
      ],
    );
  }
}
