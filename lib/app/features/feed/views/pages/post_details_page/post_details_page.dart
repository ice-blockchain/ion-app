// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/async_value_listener.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/providers/post_reply/send_reply_request_notifier.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/components/reply_input_field/reply_input_field.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/components/reply_list/reply_list.dart';
import 'package:ion/app/features/feed/views/pages/post_details_page/components/reply_sent_notification/reply_sent_notification.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';
import 'package:ion/generated/assets.gen.dart';

class PostDetailsPage extends HookConsumerWidget {
  const PostDetailsPage({
    required this.postId,
    required this.pubkey,
    super.key,
  });

  final String postId;

  final String pubkey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showReplySentNotification = useState(false);
    _listenReplySentNotification(ref, showReplySentNotification);

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
                  child: ScreenSideOffset.small(
                    child: Post(postId: postId, pubkey: pubkey),
                  ),
                ),
                SliverToBoxAdapter(child: FeedListSeparator()),
                ReplyList(postId: postId, pubkey: pubkey),
              ],
            ),
          ),
          const HorizontalSeparator(),
          ReplyInputField(postId: postId, pubkey: pubkey),
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
