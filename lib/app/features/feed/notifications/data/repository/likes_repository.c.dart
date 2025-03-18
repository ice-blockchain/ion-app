// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/models/entities/reaction_data.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/dao/likes_dao.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.dart';
import 'package:ion/app/features/feed/notifications/data/model/ion_connect_notification.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'likes_repository.c.g.dart';

@Riverpod(keepAlive: true)
LikesRepository likesRepository(Ref ref) => LikesRepository(
      likesDao: ref.watch(likesDaoProvider),
      currentUserPubkey: ref.watch(currentPubkeySelectorProvider),
    );

class LikesRepository {
  LikesRepository({
    required LikesDao likesDao,
    required String? currentUserPubkey,
  })  : _likesDao = likesDao,
        _currentUserPubkey = currentUserPubkey;

  final LikesDao _likesDao;
  final String? _currentUserPubkey;

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

  Future<List<LikesIonNotification>> getAggregated() async {
    if (_currentUserPubkey == null) {
      return [];
    }

    final aggregated = await _likesDao.getAggregated();
    return aggregated
        .map(
          (result) => LikesIonNotification(
            eventReference: result.eventReference,
            timestamp: DateTime.parse(result.eventDate),
            pubkeys: result.latestPubkeys?.split(',') ?? [],
          ),
        )
        .toList();
  }

  Future<DateTime?> lastCreatedAt() async {
    return _likesDao.getLastCreatedAt();
  }
}
