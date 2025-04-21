// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/comments_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/repository/ion_notification_repository.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_repository.c.g.dart';

@Riverpod(keepAlive: true)
CommentsRepository commentsRepository(Ref ref) => CommentsRepository(
      commentsDao: ref.watch(commentsDaoProvider),
    );

class CommentsRepository implements IonNotificationRepository {
  CommentsRepository({
    required CommentsDao commentsDao,
  }) : _commentsDao = commentsDao;

  final CommentsDao _commentsDao;

  @override
  Future<void> save(IonConnectEntity entity) {
    final type = switch (entity) {
      ModifiablePostEntity() when entity.data.quotedEvent != null => CommentType.quote,
      ModifiablePostEntity() when entity.data.parentEvent != null => CommentType.reply,
      GenericRepostEntity() => CommentType.repost,
      _ => throw UnknownNotificationCommentException(entity),
    };
    return _commentsDao.insert(
      Comment(
        eventReference: entity.toEventReference(),
        createdAt: entity.createdAt,
        type: type,
      ),
    );
  }

  @override
  Future<List<CommentIonNotification>> getNotifications() async {
    final comments = await _commentsDao.getAll();
    return comments.map((comment) {
      final type = switch (comment.type) {
        CommentType.quote => CommentIonNotificationType.quote,
        CommentType.reply => CommentIonNotificationType.reply,
        CommentType.repost => CommentIonNotificationType.repost,
      };
      return CommentIonNotification(
        type: type,
        eventReference: comment.eventReference,
        timestamp: comment.createdAt,
      );
    }).toList();
  }

  Future<DateTime?> lastCreatedAt(CommentIonNotificationType type) async {
    final commentType = switch (type) {
      CommentIonNotificationType.quote => CommentType.quote,
      CommentIonNotificationType.reply => CommentType.reply,
      CommentIonNotificationType.repost => CommentType.repost,
    };
    return _commentsDao.getLastCreatedAt(commentType);
  }

  Future<DateTime?> firstCreatedAt(CommentIonNotificationType type, {DateTime? after}) async {
    final commentType = switch (type) {
      CommentIonNotificationType.quote => CommentType.quote,
      CommentIonNotificationType.reply => CommentType.reply,
      CommentIonNotificationType.repost => CommentType.repost,
    };
    return _commentsDao.getFirstCreatedAt(commentType, after: after);
  }
}
