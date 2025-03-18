// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/notifications/providers/followers_notifications_provider.c.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_item.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs/empty_list.dart';

class FollowersNotificationsList extends HookConsumerWidget {
  const FollowersNotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final followers = ref.watch(followersNotificationsProvider).valueOrNull;

    return PullToRefreshBuilder(
      slivers: [
        if (followers == null)
          const EntitiesListSkeleton()
        else if (followers.isEmpty)
          const EmptyState()
        else
          SliverList.builder(
            itemCount: followers.length,
            itemBuilder: (context, index) {
              return NotificationItem(notification: followers[index]);
            },
          ),
      ],
      onRefresh: () async => ref.invalidate(followersNotificationsProvider),
      builder: (context, slivers) => CustomScrollView(slivers: slivers),
    );
  }
}
