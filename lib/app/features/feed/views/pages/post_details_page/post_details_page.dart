import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ice/app/components/screen_offset/screen_side_offset.dart';
import 'package:ice/app/components/separated/separator.dart';
import 'package:ice/app/extensions/extensions.dart';
import 'package:ice/app/features/feed/providers/posts_provider.dart';
import 'package:ice/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ice/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ice/app/features/feed/views/components/post/components/post_footer/post_details_footer.dart';
import 'package:ice/app/features/feed/views/components/post/post.dart';
import 'package:ice/app/features/feed/views/components/post_list/post_list.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/components/post_not_found/post_not_found.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/components/reply_input_field/reply_input_field.dart';
import 'package:ice/app/features/feed/views/pages/post_details_page/components/reply_sent_notification/reply_sent_notification.dart';
import 'package:ice/app/hooks/use_on_init.dart';
import 'package:ice/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ice/app/extensions/async_value_listener.dart';
import 'package:ice/generated/assets.gen.dart';

class PostDetailsPage extends HookConsumerWidget {
  const PostDetailsPage({
    required this.postId,
    super.key,
  });

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postData = ref.watch(postByIdProvider(postId: postId));
    final replyIds = ref.watch(postReplyIdsProvider(postId: postId));

    useOnInit(() {
      ref.read(postsProvider.notifier).fetchPostReplies(postId: postId);
    });

    final showReplySentNotification = useState(false);
    _listenReplySentNotification(ref, showReplySentNotification);

    if (postData == null) {
      return PostNotFound();
    }

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(context.i18n.post_page_title),
        actions: [
          IconButton(
            icon: Assets.svg.iconBookmarks.icon(
              size: NavigationAppBar.actionButtonSide,
              color: context.theme.appColors.primaryText,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AnimatedCrossFade(
                    crossFadeState: showReplySentNotification.value
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300),
                    firstChild: SizedBox.shrink(),
                    secondChild: ScreenSideOffset.small(
                      child: ReplySentNotification(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Post(
                    postData: postData,
                    footer: PostDetailsFooter(
                      postData: postData,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: FeedListSeparator()),
                PostList(
                  postIds: replyIds,
                  separator: FeedListSeparator(height: 1.0.s),
                ),
              ],
            ),
          ),
          HorizontalSeparator(),
          ReplyInputField(postData: postData),
        ],
      ),
    );
  }

  void _listenReplySentNotification(
    WidgetRef ref,
    ValueNotifier<bool> showReplySentNotification,
  ) {
    ref.listenAsyncValue(
      sendReplyRequestNotifierProvider,
      onSuccess: (response) async {
        showReplySentNotification.value = true;
        await Future<void>.delayed(Duration(seconds: 2));
        showReplySentNotification.value = false;
      },
    );
  }
}
