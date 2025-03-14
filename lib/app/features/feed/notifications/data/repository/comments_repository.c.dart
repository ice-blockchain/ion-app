// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/feed/data/models/entities/modifiable_post_data.c.dart';
import 'package:ion/app/features/feed/data/models/generic_repost.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/comments_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comments_repository.c.g.dart';

@Riverpod(keepAlive: true)
CommentsRepository commentsRepository(Ref ref) => CommentsRepository(
      commentsDao: ref.watch(commentsDaoProvider),
    );

class CommentsRepository {
  CommentsRepository({
    required CommentsDao commentsDao,
  }) : _commentsDao = commentsDao;

  final CommentsDao _commentsDao;

  Future<void> save(IonConnectEntity entity) {
    final type = switch (entity) {
      ModifiablePostEntity() when entity.data.quotedEvent != null => CommentType.quote,
      ModifiablePostEntity() when entity.data.parentEvent != null => CommentType.reply,
      GenericRepostEntity() when entity.data.kind == ModifiablePostEntity.kind =>
        CommentType.repost,
      _ => throw UnknownNotificationCommentException(entity),
    };
    return _commentsDao.insert(entity, type: type);
  }

  Future<List<IonConnectNotification>> getComments() async {
    final comments = await _commentsDao.getAll();
    return comments.map((comment) {
      final type = switch (comment.type) {
        CommentType.quote => NotificationsType.quote,
        CommentType.reply => NotificationsType.reply,
        CommentType.repost => NotificationsType.repost,
      };
      return IonConnectNotification(
        type: type,
        pubkeys: [comment.eventReference.pubkey],
        timestamp: comment.createdAt,
        eventReference: comment.eventReference,
      );
    }).toList();
  }

  Future<DateTime?> lastCreatedAt(NotificationsType type) async {
    final commentType = switch (type) {
      NotificationsType.quote => CommentType.quote,
      NotificationsType.reply => CommentType.reply,
      NotificationsType.repost => CommentType.repost,
      _ => throw UnknownNotificationCommentException(type)
    };
    return _commentsDao.getLastCreatedAt(commentType);
  }
}
