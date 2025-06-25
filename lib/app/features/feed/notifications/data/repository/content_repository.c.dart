// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/article_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/generic_repost.c.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/entities/post_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/content_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/content_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/ion_notification_repository.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'content_repository.c.g.dart';

@Riverpod(keepAlive: true)
ContentRepository contentRepository(Ref ref) => ContentRepository(
      contentDao: ref.watch(contentDaoProvider),
    );

class ContentRepository implements IonNotificationRepository {
  ContentRepository({
    required ContentDao contentDao,
  }) : _contentDao = contentDao;

  final ContentDao _contentDao;

  @override
  Future<void> save(IonConnectEntity entity) {
    final contentType = _getContentType(entity);
    if (contentType == null) throw UnsupportedEntityType(entity);

    return _contentDao.insert(
      ContentNotification(
        eventReference: entity.toEventReference(),
        createdAt: entity.createdAt,
        type: contentType,
      ),
    );
  }

  @override
  Future<List<ContentIonNotification>> getNotifications() async {
    final contentNotifications = await _contentDao.getAll();
    return contentNotifications.map((content) {
      final notificationType = switch (content.type) {
        ContentType.posts => ContentIonNotificationType.posts,
        ContentType.stories => ContentIonNotificationType.stories,
        ContentType.articles => ContentIonNotificationType.articles,
        ContentType.videos => ContentIonNotificationType.videos,
      };
      return ContentIonNotification(
        type: notificationType,
        eventReference: content.eventReference,
        timestamp: content.createdAt.toDateTime,
      );
    }).toList();
  }

  ContentType? _getContentType(IonConnectEntity entity) {
    return switch (entity) {
      PostEntity() when entity.data.videos.isNotEmpty == true => ContentType.videos,
      PostEntity() when entity.data.expiration != null => ContentType.stories,
      PostEntity() => ContentType.posts,
      ModifiablePostEntity() when entity.data.videos.isNotEmpty == true => ContentType.videos,
      ModifiablePostEntity() when entity.data.expiration != null => ContentType.stories,
      ModifiablePostEntity() => ContentType.posts,
      ArticleEntity() => ContentType.articles,
      GenericRepostEntity() when entity.data.kind == ArticleEntity.kind => ContentType.articles,
      GenericRepostEntity() => ContentType.posts,
      _ => null,
    };
  }

  Future<DateTime?> lastCreatedAt() async {
    return _contentDao.getLastCreatedAt();
  }
}
