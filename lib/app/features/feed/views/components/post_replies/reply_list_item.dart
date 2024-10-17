// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/data/models/post/post_data.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/nostr/providers/nostr_cache.dart';
import 'package:ice/app/router/app_routes.dart';

class ReplyListItem extends ConsumerWidget {
  const ReplyListItem({required this.postId, super.key});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(nostrCacheProvider.select(cacheSelector<PostData>(postId)));

    if (post == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: postId).push<void>(context),
      child: Post(header: PostHeader(pubkey: post.pubkey), postData: post),
    );
  }
}
