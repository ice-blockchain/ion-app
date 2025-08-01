// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/components/screen_offset/screen_side_offset.dart';
import 'package:ion/app/components/section_separator/section_separator.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.f.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_icons.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_info.dart';
import 'package:ion/app/features/feed/notifications/views/notifications_history_page/components/notification_item/notification_related_entity.dart';
import 'package:ion/app/features/feed/providers/ion_connect_entity_with_counters_provider.r.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/features/ion_connect/model/soft_deletable_entity.dart';
import 'package:ion/app/router/app_routes.gr.dart';

class NotificationItem extends ConsumerWidget {
  const NotificationItem({
    required this.notification,
    super.key,
  });

  final IonNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventReference = switch (notification) {
      final CommentIonNotification comment => comment.eventReference,
      final LikesIonNotification likes => likes.eventReference,
      final ContentIonNotification content => content.eventReference,
      _ => null,
    };

    IonConnectEntity? entity;

    if (eventReference != null) {
      entity = ref.watch(ionConnectEntityWithCountersProvider(eventReference: eventReference));
      if (entity == null || _isDeleted(ref, entity) || _isRepostedEntityDeleted(ref, entity)) {
        return const SizedBox.shrink();
      }
    }

    return GestureDetector(
      onTap: () => _onTap(context, entity),
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.0.s),
          ScreenSideOffset.small(
            child: NotificationIcons(notification: notification),
          ),
          SizedBox(height: 8.0.s),
          ScreenSideOffset.small(
            child: NotificationInfo(
              notification: notification,
            ),
          ),
          if (entity != null)
            NotificationRelatedEntity(
              entity: entity,
              notification: notification,
            ),
          SizedBox(height: 16.0.s),
          const SectionSeparator(),
        ],
      ),
    );
  }

  bool _isDeleted(WidgetRef ref, IonConnectEntity entity) {
    return entity is SoftDeletableEntity && entity.isDeleted;
  }

  bool _isRepostedEntityDeleted(WidgetRef ref, IonConnectEntity entity) {
    if (entity is GenericRepostEntity) {
      final repostedEntity = ref
          .watch(ionConnectEntityWithCountersProvider(eventReference: entity.data.eventReference));
      return repostedEntity == null ||
          (repostedEntity is SoftDeletableEntity && repostedEntity.isDeleted);
    }
    return false;
  }

  void _onTap(BuildContext context, IonConnectEntity? entity) {
    if (entity == null) {
      return;
    }

    final eventReference = switch (entity) {
      final GenericRepostEntity repost => repost.data.eventReference,
      _ => entity.toEventReference(),
    };

    if (eventReference.isArticleReference) {
      ArticleDetailsRoute(eventReference: eventReference.encode()).push<void>(context);
    } else {
      PostDetailsRoute(eventReference: eventReference.encode()).push<void>(context);
    }
  }
}
