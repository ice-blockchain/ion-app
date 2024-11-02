// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/feed_data_provider.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list_skeleton.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class FeedPosts extends HookConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postIds = ref.watch(feedDataProvider);

    useOnInit(
      () {
        if (postIds?.dataSource != null) {
          ref.read(feedDataProvider.notifier).fetchPosts();
        }
      },
      [postIds?.dataSource],
    );

    if (postIds == null) {
      return const PostListSkeleton();
    }

    return PostList(postIds: postIds.data.items.toList());
  }
}
