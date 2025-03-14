// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/likes_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/notifications_type.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_repository.c.g.dart';

@Riverpod(keepAlive: true)
LikesRepository likesRepository(Ref ref) => LikesRepository(
      likesDao: ref.watch(likesDaoProvider),
    );

class LikesRepository {
  LikesRepository({
    required LikesDao likesDao,
  }) : _likesDao = likesDao;

  final LikesDao _likesDao;

  Future<void> save(IonConnectEntity entity) {
    return _likesDao.insert(entity);
  }

  Future<List<IonConnectNotification>> getComments() async {
    //TODO:aggregation
    final likes = await _likesDao.getAll();
    return likes.map((comment) {
      return IonConnectNotification(
        type: NotificationsType.like,
        pubkeys: [comment.eventReference.pubkey],
        timestamp: comment.createdAt,
        eventReference: comment.eventReference,
      );
    }).toList();
  }

  Future<DateTime?> lastCreatedAt() async {
    return _likesDao.getLastCreatedAt();
  }
}
