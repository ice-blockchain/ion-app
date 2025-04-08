// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:ion/app/router/app_routes.c.dart';

class NotificationRelatedEntity extends StatelessWidget {
  const NotificationRelatedEntity({required this.entity, required this.notification, super.key});

  final IonConnectEntity entity;

  final IonNotification notification;

  @override
  Widget build(BuildContext context) {
    final eventReference = switch (entity) {
      final GenericRepostEntity repost => repost.data.eventReference,
      _ => entity.toEventReference(),
    };

    if (eventReference is ReplaceableEventReference && eventReference.kind == ArticleEntity.kind) {
      return Padding(
        padding: EdgeInsetsDirectional.only(top: 12.0.s, end: 16.0.s),
        child: GestureDetector(
          onTap: () {
            ArticleDetailsRoute(eventReference: entity.toEventReference().encode())
                .push<void>(context);
          },
          child: Article(
            eventReference: eventReference,
            header: const SizedBox.shrink(),
            footer: const SizedBox.shrink(),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        PostDetailsRoute(eventReference: eventReference.encode()).push<void>(context);
      },
      child: Post(
        eventReference: eventReference,
        header: const SizedBox.shrink(),
        footer: const SizedBox.shrink(),
        topOffset: 6.0.s,
        headerOffset: 0,
      ),
    );
  }
}
