// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/dao/seen_events_dao.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.c.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:ion/app/features/ion_connect/model/ion_connect_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'following_feed_seen_events_repository.c.g.dart';

@Riverpod(keepAlive: true)
FollowingFeedSeenEventsRepository followingFeedSeenEventsRepository(Ref ref) =>
    FollowingFeedSeenEventsRepository(
      seenEventsDao: ref.watch(seenEventsDaoProvider),
    );

class FollowingFeedSeenEventsRepository {
  FollowingFeedSeenEventsRepository({
    required SeenEventsDao seenEventsDao,
  }) : _seenEventsDao = seenEventsDao;

  final SeenEventsDao _seenEventsDao;

  Future<void> save(
    IonConnectEntity entity, {
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    return _seenEventsDao.insert(
      SeenEvent(
        eventReference: entity.toEventReference(),
        createdAt: entity.createdAt,
        feedType: feedType,
        feedModifier: feedModifier,
        pubkey: entity.masterPubkey,
      ),
    );
  }

  Future<void> setNextEvent({
    required EventReference eventReference,
    required EventReference nextEventReference,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    return _seenEventsDao.updateNextEvent(
      eventReference: eventReference,
      feedType: feedType,
      feedModifier: feedModifier,
      nextEventReference: nextEventReference,
    );
  }

  Future<({EventReference eventReference, int createdAt})?> getSeenSequenceEnd({
    required EventReference eventReference,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    final seenEvent = await _seenEventsDao.getByReference(
      eventReference: eventReference,
      feedType: feedType,
      feedModifier: feedModifier,
    );

    if (seenEvent == null) return null;
    if (seenEvent.nextEventReference == null) {
      return (createdAt: seenEvent.createdAt, eventReference: seenEvent.eventReference);
    }

    final seenSequenceEnd = await _seenEventsDao.getFirstWithoutNext(
      since: seenEvent.createdAt,
      feedType: feedType,
      feedModifier: feedModifier,
    );

    if (seenSequenceEnd == null) {
      return (createdAt: seenEvent.createdAt, eventReference: seenEvent.eventReference);
    }

    return (createdAt: seenSequenceEnd.createdAt, eventReference: seenSequenceEnd.eventReference);
  }

  Future<List<EventReference>> getEventReferences({
    required FeedType feedType,
    required List<EventReference> exclude,
    required int limit,
    required int since,
    FeedModifier? feedModifier,
  }) {
    return _seenEventsDao.getEventReferencesExcluding(
      feedType: feedType,
      feedModifier: feedModifier,
      exclude: exclude,
      limit: limit,
      since: since,
    );
  }
}
