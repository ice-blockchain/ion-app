// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/async_value_listener.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/post_data.dart';
import 'package:ion/app/features/feed/providers/post_replies_provider.dart';
import 'package:ion/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ion/app/features/feed/views/components/entities_list/entities_list.dart';
import 'package:ion/app/features/feed/views/components/feed_item/feed_item_footer/feed_item_details_footer.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/components/post_not_found/post_not_found.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/components/reply_input_field/reply_input_field.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/components/reply_sent_notification/reply_sent_notification.dart';
import 'package:ion/app/features/nostr/providers/nostr_cache.dart';
import 'package:ion/app/hooks/use_on_init.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/generated/assets.gen.dart';

class PostDetailsPage extends HookConsumerWidget {
  const PostDetailsPage({
    required this.postId,
    super.key,
  });

  final String postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postEntity = ref.watch(nostrCacheProvider.select(cacheSelector<PostEntity>(postId)));
    final replies = ref.watch(postRepliesSelectorProvider(postId: postId));

    useOnInit(() {
      ref.read(postRepliesProvider.notifier).fetchReplies(postId: postId);
    });

    final showReplySentNotification = useState(false);
    _listenReplySentNotification(ref, showReplySentNotification);

    if (postEntity == null) {
      return const PostNotFound();
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
                    duration: const Duration(milliseconds: 300),
                    firstChild: const SizedBox.shrink(),
                    secondChild: ScreenSideOffset.small(
                      child: const ReplySentNotification(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Post(
                    postEntity: postEntity,
                    footer: FeedItemDetailsFooter(
                      postEntity: postEntity,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: FeedListSeparator()),
                EntitiesList(
                  entities: replies,
                  separator: FeedListSeparator(height: 1.0.s),
                ),
              ],
            ),
          ),
          const HorizontalSeparator(),
          ReplyInputField(postEntity: postEntity),
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
        await Future<void>.delayed(const Duration(seconds: 2));
        showReplySentNotification.value = false;
      },
    );
  }
}
