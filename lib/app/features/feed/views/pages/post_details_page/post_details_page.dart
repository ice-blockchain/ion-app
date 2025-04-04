// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/separated/separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/components/entities_list/components/bookmark_button/bookmark_button.dart';
import 'package:ion/app/features/feed/create_post/views/components/reply_input_field/reply_input_field.dart';
import 'package:ion/app/features/feed/providers/can_reply_notifier.c.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/reply_list/reply_list.dart';
import 'package:ion/app/features/feed/views/components/time_ago/time_ago.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/router/components/navigation_app_bar/navigation_app_bar.dart';

class PostDetailsPage extends ConsumerWidget {
  const PostDetailsPage({
    required this.eventReference,
    super.key,
  });

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canReply = ref.watch(canReplyProvider(eventReference)).value ?? false;

    return Scaffold(
      appBar: NavigationAppBar.screen(
        title: Text(context.i18n.post_page_title),
        actions: [
          BookmarkButton(eventReference: eventReference),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: ReplyList(
              eventReference: eventReference,
              headers: [
                SliverToBoxAdapter(
                  child: Post(
                    eventReference: eventReference,
                    timeFormat: TimestampFormat.detailed,
                    onDelete: context.pop,
                    isTextSelectable: true,
                    bodyMaxLines: null,
                  ),
                ),
                SliverToBoxAdapter(child: FeedListSeparator()),
              ],
            ),
          ),
          if (canReply) ...[
            const HorizontalSeparator(),
            ReplyInputField(eventReference: eventReference),
          ],
        ],
      ),
    );
  }
}
