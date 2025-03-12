// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/notifications/providers/notification_comments_provider.c.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_item.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs/empty_list.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';

class CommentsNotifications extends HookConsumerWidget {
  const CommentsNotifications({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final comments = ref.watch(notificationCommentsProvider).valueOrNull;

    return CustomScrollView(
      slivers: [
        if (comments == null)
          const EntitiesListSkeleton()
        else if (comments.isEmpty)
          const EmptyState()
        else
          SliverList.separated(
            separatorBuilder: (context, index) => FeedListSeparator(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return NotificationItem(notification: comments[index]);
            },
          ),
      ],
    );
  }
}
