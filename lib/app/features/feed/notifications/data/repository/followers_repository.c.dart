// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/followers_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'followers_repository.c.g.dart';

@Riverpod(keepAlive: true)
FollowersRepository followersRepository(Ref ref) => FollowersRepository(
      followersDao: ref.watch(followersDaoProvider),
    );

class FollowersRepository {
  FollowersRepository({
    required FollowersDao followersDao,
  }) : _followersDao = followersDao;

  final FollowersDao _followersDao;

  Future<void> save(IonConnectEntity entity) {
    return _followersDao.insert(entity);
  }

  Future<List<FollowersIonNotification>> getAggregated() async {
    final aggregated = await _followersDao.getAggregated();
    return aggregated
        .map(
          (result) => FollowersIonNotification(
            timestamp: DateTime.parse(result.eventDate),
            pubkeys: result.latestPubkeys?.split(',') ?? [],
          ),
        )
        .toList();
  }

  Future<DateTime?> lastCreatedAt() async {
    return _followersDao.getLastCreatedAt();
  }
}
