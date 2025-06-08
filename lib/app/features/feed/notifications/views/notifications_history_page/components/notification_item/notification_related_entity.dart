// SPDX-License-Identifier: ice License 1.0

import 'package:flutter/material.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/views/components/article/article.dart';
import 'package:ion/app/features/feed/views/components/post/post.dart';
import 'package:ion/app/features/ion_connect/data/models/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';

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

    if (eventReference.isArticleReference) {
      return Padding(
        padding: EdgeInsetsDirectional.only(top: 12.0.s, end: 16.0.s),
        child: Article(
          eventReference: eventReference,
          header: const SizedBox.shrink(),
          footer: const SizedBox.shrink(),
        ),
      );
    }

    return Post(
      eventReference: eventReference,
      header: const SizedBox.shrink(),
      footer: const SizedBox.shrink(),
      topOffset: 6.0.s,
      headerOffset: 0,
    );
  }
}
