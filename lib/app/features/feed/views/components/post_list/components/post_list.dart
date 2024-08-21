import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/features/feed/model/post/post_data.dart';
import 'package:ice/app/features/feed/providers/posts_provider.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_footer.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/components/post_replies/post_replies.dart';
import 'package:ice/app/hooks/use_on_init.dart';

class PostList extends StatelessWidget {
  const PostList({
    required this.postIds,
    this.separator,
    super.key,
  });

  final List<String> postIds;
  final Widget? separator;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: postIds.length,
      separatorBuilder: (BuildContext context, int index) {
        return separator ?? FeedListSeparator();
      },
      itemBuilder: (BuildContext context, int index) {
        final postId = postIds[index];
        return _PostBuilder(
          postId: postId,
          builder: (context, postData, replyIds) => Post(
            postData: postData,
            footer: Column(
              children: [
                PostFooter(postData: postData),
                if (postIds.length > 0) PostReplies(postIds: replyIds),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PostBuilder extends HookConsumerWidget {
  const _PostBuilder({required this.postId, required this.builder});

  final String postId;

  final Widget Function(BuildContext context, PostData data, List<String> replyIds) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final post = ref.watch(postByIdProvider(postId: postId));
    final replyIds = ref.watch(postReplyIdsProvider(postId: postId));

    useOnInit(() {
      ref.read(postsProvider.notifier).fetchPostReplies(postId: postId);
    });

    if (post == null) return SizedBox.shrink();
    return builder(context, post, replyIds);
  }
}
