import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/feed_search/providers/feed_search_users_provider.dart';
import 'package:ice/app/features/feed/feed_search/views/pages/feed_advanced_search_page/components/feed_advanced_search_users/feed_advanced_search_user_list_item.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list_skeleton.dart';

class FeedAdvancedSearchUsers extends HookConsumerWidget {
  const FeedAdvancedSearchUsers({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final usersSearchResults = ref.watch(feedSearchUsersProvider(query));

    return CustomScrollView(
      slivers: [
        usersSearchResults.maybeWhen(
          data: (users) {
            if (users == null) {
              return SizedBox.shrink();
            }

            return SliverList.separated(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return FeedAdvancedSearchUserListItem(user: users[index]);
              },
              separatorBuilder: (_, __) => FeedListSeparator(),
            );
          },
          orElse: () => PostListSkeleton(),
        )
      ],
    );
  }
}