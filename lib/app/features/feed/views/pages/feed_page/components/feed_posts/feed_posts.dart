// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/providers/feed_post_ids_provider.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ion/app/features/feed/views/components/post_list/post_list_skeleton.dart';

class FeedPosts extends ConsumerWidget {
  const FeedPosts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postIds = ref.watch(feedPostIdsProvider);

    return postIds.maybeWhen(
      data: (data) {
        return PostList(postIds: data);
      },
      orElse: () => const PostListSkeleton(),
    );
  }
}
