// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_icon.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_info.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/user_avatar.dart';
import 'package:ion/app/features/feed/views/components/list_separator/list_separator.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/soft_deletable_entity.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class NotificationItem extends ConsumerWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });

  final IonNotification notification;

  static double get separator => 4.0.s;

  static int get iconsCount => 10;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconSize = ((MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2) -
            separator * (iconsCount - 1)) /
        iconsCount;

    //TODO:refactor!
    final eventReference = switch (notification) {
      final CommentIonNotification comment => comment.eventReference,
      final LikesIonNotification likes => likes.eventReference,
    };
    IonConnectEntity? entity;

    // Hide the item if repost / post is deleted.
    entity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));
    if (entity == null || (entity is SoftDeletableEntity && entity.isDeleted)) {
      return const SizedBox.shrink();
    }

    // Hide the item if reposted event is deleted.
    if (entity is GenericRepostEntity) {
      final repostedEntity =
          ref.watch(ionConnectSyncEntityProvider(eventReference: entity.data.eventReference));
      if (repostedEntity == null ||
          (repostedEntity is SoftDeletableEntity && repostedEntity.isDeleted)) {
        return const SizedBox.shrink();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.0.s),
        ScreenSideOffset.small(
          child: Row(
            children: [
              NotificationIcon(
                asset: notification.asset,
                backgroundColor: notification.getBackgroundColor(context),
                size: iconSize,
              ),
              ...notification.pubkeys.take(iconsCount - 1).map((pubkey) {
                return Padding(
                  padding: EdgeInsets.only(left: separator),
                  child: UserAvatar(
                    pubkey: pubkey,
                    avatarSize: iconSize,
                  ),
                );
              }),
            ],
          ),
        ),
        SizedBox(height: 8.0.s),
        ScreenSideOffset.small(
          child: NotificationInfo(notification: notification),
        ),
        GestureDetector(
          onTap: () {
            PostDetailsRoute(eventReference: entity!.toEventReference().encode())
                .push<void>(context);
          },
          child: _NotificationItemEvent(entity: entity),
        ),
        SizedBox(height: 16.0.s),
        FeedListSeparator(),
      ],
    );
  }
}

class _NotificationItemEvent extends ConsumerWidget {
  const _NotificationItemEvent({required this.entity});

  final IonConnectEntity entity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainEventReference = switch (entity) {
      final GenericRepostEntity repost => repost.data.eventReference,
      _ => entity.toEventReference(),
    };

    return Post(
      eventReference: mainEventReference,
      header: const SizedBox.shrink(),
      footer: const SizedBox.shrink(),
      topOffset: 6.0.s,
      headerOffset: 0,
    );
  }
}
