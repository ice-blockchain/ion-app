// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/likes_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/models/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/providers/dao/likes_dao_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/repository/ion_notification_repository.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_repository.c.g.dart';

@Riverpod(keepAlive: true)
LikesRepository likesRepository(Ref ref) => LikesRepository(
      likesDao: ref.watch(likesDaoProvider),
    );

class LikesRepository implements IonNotificationRepository {
  LikesRepository({
    required LikesDao likesDao,
  }) : _likesDao = likesDao;

  final LikesDao _likesDao;

  @override
  Future<void> save(IonConnectEntity entity) {
    if (entity is! ReactionEntity) {
      throw UnsupportedEventReference(entity.toEventReference());
    }
    final like = Like(
      eventReference: entity.data.eventReference,
      pubkey: entity.masterPubkey,
      createdAt: entity.createdAt,
    );
    return _likesDao.insert(like);
  }

  @override
  Future<List<LikesIonNotification>> getNotifications() async {
    final aggregated = await _likesDao.getAggregated();
    return aggregated
        .map(
          (result) => LikesIonNotification(
            total: result.uniquePubkeyCount,
            eventReference: result.eventReference,
            timestamp: result.lastCreatedAt?.toDateTime ?? DateTime.fromMillisecondsSinceEpoch(0),
            pubkeys: result.latestPubkeys?.split(',') ?? [],
          ),
        )
        .toList();
  }

  Future<DateTime?> lastCreatedAt() async {
    return _likesDao.getLastCreatedAt();
  }

  Future<DateTime?> firstCreatedAt({DateTime? after}) async {
    return _likesDao.getFirstCreatedAt(after: after);
  }
}
