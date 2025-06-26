// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/scroll_view/pull_to_refresh_builder.dart';
import 'package:ion/app/features/components/entities_list/entities_list_skeleton.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_tab_type.dart';
import 'package:ion/app/features/feed/notifications/providers/tab_notifications_provider.r.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_item.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs/empty_list.dart';

class NotificationsTab extends HookConsumerWidget {
  const NotificationsTab({
    required this.type,
    super.key,
  });

  final NotificationsTabType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useAutomaticKeepAlive();

    final notifications = ref.watch(tabNotificationsProvider(type: type)).valueOrNull;

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
      onRefresh: () async => ref.invalidate(tabNotificationsProvider(type: type)),
      builder: (context, slivers) => CustomScrollView(slivers: slivers),
    );
  }
}
