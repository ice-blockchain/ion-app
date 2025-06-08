// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/followers_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/models/ion_notification.c.dart';
import 'package:ion/app/features/feed/notifications/providers/dao/followers_dao_provider.c.dart';
import 'package:ion/app/features/feed/notifications/providers/repository/ion_notification_repository.dart';
import 'package:ion/app/features/ion_connect/data/models/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_repository.c.g.dart';

@Riverpod(keepAlive: true)
FollowersRepository followersRepository(Ref ref) => FollowersRepository(
      followersDao: ref.watch(followersDaoProvider),
    );

class FollowersRepository implements IonNotificationRepository {
  FollowersRepository({
    required FollowersDao followersDao,
  }) : _followersDao = followersDao;

  final FollowersDao _followersDao;

  @override
  Future<void> save(IonConnectEntity entity) {
    return _followersDao.insert(
      Follower(pubkey: entity.masterPubkey, createdAt: entity.createdAt),
    );
  }

  @override
  Future<List<FollowersIonNotification>> getNotifications() async {
    final aggregated = await _followersDao.getAggregated();
    return aggregated
        .map(
          (result) => FollowersIonNotification(
            total: result.uniquePubkeyCount,
            timestamp: result.lastCreatedAt?.toDateTime ?? DateTime.fromMillisecondsSinceEpoch(0),
            pubkeys: result.latestPubkeys?.split(',') ?? [],
          ),
        )
        .toList();
  }

  Future<DateTime?> lastCreatedAt() async {
    return _followersDao.getLastCreatedAt();
  }

  Future<DateTime?> firstCreatedAt({DateTime? after}) async {
    return _followersDao.getFirstCreatedAt(after: after);
  }
}
