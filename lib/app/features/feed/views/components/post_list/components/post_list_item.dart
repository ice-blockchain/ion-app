import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/providers/posts_store_provider.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/components/post_replies/post_replies.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/app_routes.dart';

class PostListItem extends HookConsumerWidget {
  const PostListItem({required this.postId});

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postByIdSelectorProvider(postId: postId));
    final replyIds = ref.watch(postReplyIdsSelectorProvider(postId: postId));

    useOnInit(() {
      ref.read(postsStoreProvider.notifier).fetchPostReplies(postId: postId);
    });

    if (post == null) return SizedBox.shrink();

    return GestureDetector(
      onTap: () => PostDetailsRoute(postId: postId).push<void>(context),
      child: Post(
        postData: post,
        footer: Column(
          children: [
            PostFooter(postData: post),
            if (replyIds.length > 0) PostReplies(postIds: replyIds),
          ],
        ),
      ),
    );
  }
}
