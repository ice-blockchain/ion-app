import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/posts_store_provider.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_header/post_header.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/router/app_routes.dart';

class ReplyListItem extends ConsumerWidget {
  const ReplyListItem({required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postByIdSelectorProvider(postId: postId));

    if (post == null) return SizedBox.shrink();

    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: postId).push<void>(context),
      child: Post(header: PostHeader(), postData: post),
    );
  }
}
