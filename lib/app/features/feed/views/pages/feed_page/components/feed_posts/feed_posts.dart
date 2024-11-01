// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/feed_post_ids_provider.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list_skeleton.dart';
import 'package:ion/app/hooks/use_on_init.dart';

class FeedPosts extends ConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postIds = ref.watch(feedPostIdsProvider).valueOrNull;

    useOnInit(() {
      ref.read(feedPostIdsProvider.notifier).fetchPosts();
    });

    if (postIds == null) {
      return const PostListSkeleton();
    }

    return PostList(postIds: postIds.items.toList());
  }
}
