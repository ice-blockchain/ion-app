// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/skeleton/skeleton.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_info.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_type_icon.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/user_avatar.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/feed/views/components/post/post_skeleton.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/providers/ion_connect_entity_provider.c.dart';
import 'package:ion/app/router/app_routes.c.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });

  final IonConnectNotification notification;

  static double get separator => 4.0.s;

  static int get iconsCount => 10;

  @override
  Widget build(BuildContext context) {
    final iconSize = ((MediaQuery.sizeOf(context).width - ScreenSideOffset.defaultSmallMargin * 2) -
            separator * (iconsCount - 1)) /
        iconsCount;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScreenSideOffset.small(
            child: Row(
              children: [
                NotificationTypeIcon(
                  notificationsType: notification.type,
                  iconSize: iconSize,
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
          if (notification.eventReference != null)
            GestureDetector(
              onTap: () {
                PostDetailsRoute(eventReference: notification.eventReference!.encode())
                    .push<void>(context);
              },
              child: _NotificationItemEvent(eventReference: notification.eventReference!),
            ),
        ],
      ),
    );
  }
}

class _NotificationItemEvent extends ConsumerWidget {
  const _NotificationItemEvent({required this.eventReference});

  final EventReference eventReference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(ionConnectSyncEntityProvider(eventReference: eventReference));

    if (entity == null) {
      return ScreenSideOffset.small(child: const Skeleton(child: PostSkeleton()));
    }

    final mainEventReference = switch (entity) {
      GenericRepostEntity() => entity.data.eventReference,
      _ => eventReference,
    };

    final framedEventType = switch (entity) {
      ModifiablePostEntity() when entity.data.parentEvent != null => FramedEventType.parent,
      _ => FramedEventType.quoted,
    };

    return Post(
      eventReference: mainEventReference,
      framedEventType: framedEventType,
      header: const SizedBox.shrink(),
      footer: const SizedBox.shrink(),
      topOffset: 6.0.s,
      headerOffset: 0,
    );
  }
}
