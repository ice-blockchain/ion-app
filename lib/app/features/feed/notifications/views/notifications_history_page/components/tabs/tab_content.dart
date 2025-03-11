// SPDX-License-Identifier: ice License 1.0

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/empty_list/empty_list.dart';
import 'package:ion/app/components/list_items_loading_state/list_items_loading_state.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/auth/providers/content_creators_data_source_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/notification_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_tab_type.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/content_separator.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_item.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/tabs/mock_data.dart';
import 'package:ion/app/features/feed/providers/feed_posts_data_source_provider.c.dart';
import 'package:ion/app/features/ion_connect/providers/entities_paged_data_provider.c.dart';
import 'package:ion/app/features/user/model/user_metadata.c.dart';
import 'package:ion/generated/assets.gen.dart';

class TabContent extends HookConsumerWidget {
  const TabContent({
    required this.tabType,
    super.key,
  });

  final NotificationsTabType tabType;

  List<NotificationData> _getMockedNotifications(
    NotificationData Function(NotificationData) getMockedNotificationData,
  ) {
    final finalMockedNotificationDataArray =
        mockedNotificationDataArray.map(getMockedNotificationData).toList();
    return switch (tabType) {
      NotificationsTabType.all => finalMockedNotificationDataArray,
      NotificationsTabType.comments => finalMockedNotificationDataArray
          .where(
            (notificationData) =>
                notificationData.type == NotificationsType.repost ||
                notificationData.type == NotificationsType.share ||
                notificationData.type == NotificationsType.reply,
          )
          .toList(),
      NotificationsTabType.followers => finalMockedNotificationDataArray
          .where((notificationData) => notificationData.type == NotificationsType.follow)
          .toList(),
      NotificationsTabType.likes => finalMockedNotificationDataArray
          .where(
            (notificationData) =>
                notificationData.type == NotificationsType.like ||
                notificationData.type == NotificationsType.likeReply,
          )
          .toList(),
    };
  }

  List<Widget> _buildSliverListItems(BuildContext context, List<NotificationData> notifications) {
    final sliverListItems = <Widget>[const ContentSeparator()];
    for (final notification in notifications) {
      sliverListItems
        ..add(
          ColoredBox(
            color: context.theme.appColors.secondaryBackground,
            child: NotificationItem(
              notificationData: notification,
            ),
          ),
        )
        ..add(const ContentSeparator());
    }

    return sliverListItems;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataSource = ref.watch(contentCreatorsDataSourceProvider);
    final feedPostsDataSource = ref.watch(feedPostsDataSourceProvider);
    final contentCreatorsPagedData = ref.watch(entitiesPagedDataProvider(dataSource));
    final contentCreators = contentCreatorsPagedData?.data.items;
    final entitiesPagedData = ref.watch(entitiesPagedDataProvider(feedPostsDataSource));
    final entities = entitiesPagedData?.data.items;

    if (contentCreators == null ||
        contentCreators.isEmpty ||
        entities == null ||
        entities.isEmpty) {
      return ListItemsLoadingState(
        itemsCount: 7,
        itemHeight: 106.0.s,
        separatorHeight: 12.0.s,
        listItemsLoadingStateType: ListItemsLoadingStateType.listView,
      );
    }

    final mockedPosts = useMemoized(
      () => entities.whereType<ModifiablePostEntity>().take(10).toList(),
      [entities],
    );

    final getMockedNotificationData = useCallback(
      (NotificationData data) {
        final random = Random();
        final dataWithUpdatedPubKeys = data.copyWith(
          pubkeys: contentCreators
              .whereType<UserMetadataEntity>()
              .take(data.pubkeys.length)
              .map((entity) => entity.masterPubkey)
              .toList(),
        );
        if ((data.type == NotificationsType.repost ||
                data.type == NotificationsType.share ||
                data.type == NotificationsType.reply) &&
            mockedPosts.isNotEmpty) {
          return dataWithUpdatedPubKeys.copyWith(
            postEntity: mockedPosts[random.nextInt(mockedPosts.length)],
          );
        }
        return dataWithUpdatedPubKeys;
      },
      [contentCreators, mockedPosts],
    );

    final notifications = _getMockedNotifications(getMockedNotificationData);

    if (notifications.isEmpty) {
      return Column(
        children: [
          const ContentSeparator(),
          Expanded(
            child: ScreenSideOffset.small(
              child: EmptyList(
                asset: Assets.svg.walletIconProfileEmptyprofile,
                title: context.i18n.notifications_empty_state,
              ),
            ),
          ),
        ],
      );
    }

    return ColoredBox(
      color: context.theme.appColors.primaryBackground,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              _buildSliverListItems(context, notifications),
            ),
          ),
        ],
      ),
    );
  }
}
