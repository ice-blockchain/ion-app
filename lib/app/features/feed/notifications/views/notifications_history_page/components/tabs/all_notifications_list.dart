// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/notifications/providers/all_notifications_provider.c.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_item.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs/empty_list.dart';

class AllNotificationsList extends HookConsumerWidget {
  const AllNotificationsList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final notifications = ref.watch(allNotificationsProvider).valueOrNull;

    return PullToRefreshBuilder(
      slivers: [
        if (notifications == null)
          const EntitiesListSkeleton()
        else if (notifications.isEmpty)
          const EmptyState()
        else
          SliverList.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return NotificationItem(notification: notifications[index]);
            },
          ),
      ],
      onRefresh: () async => ref.invalidate(allNotificationsProvider),
      builder: (context, slivers) => CustomScrollView(slivers: slivers),
    );
  }
}
