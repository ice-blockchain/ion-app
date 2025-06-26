// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.m.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/seen_events_table.d.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

part 'seen_events_dao.d.g.dart';

@DriftAccessor(tables: [SeenEventsTable])
class SeenEventsDao extends DatabaseAccessor<FollowingFeedDatabase> with _$SeenEventsDaoMixin {
  SeenEventsDao({required FollowingFeedDatabase db}) : super(db);

  Future<void> insert(SeenEvent event) async {
    await into(db.seenEventsTable).insert(
      event.copyWith(createdAt: event.createdAt.toMicroseconds),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> updateNextEvent({
    required EventReference eventReference,
    required EventReference? nextEventReference,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    final query = update(db.seenEventsTable)
      ..where((table) => table.eventReference.equalsValue(eventReference))
      ..where((table) => table.feedType.equalsValue(feedType))
      ..where(
        (table) => feedModifier == null
            ? table.feedModifier.isNull()
            : table.feedModifier.equalsValue(feedModifier),
      );

    await query.write(
      SeenEventsTableCompanion(
        nextEventReference: Value(nextEventReference),
      ),
    );
  }

  Future<SeenEvent?> getByReference({
    required EventReference eventReference,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    final query = select(db.seenEventsTable)
      ..where((tbl) => tbl.eventReference.equalsValue(eventReference))
      ..where((tbl) => tbl.feedType.equalsValue(feedType))
      ..where(
        (tbl) => feedModifier == null
            ? tbl.feedModifier.isNull()
            : tbl.feedModifier.equalsValue(feedModifier),
      );

    return query.getSingleOrNull();
  }

  /// Finds the end of the sequence -
  /// the first older event starting from [since] for provided [feedType] + [feedModifier]
  /// without [nextEventReference], ordered by createdAt
  Future<SeenEvent?> getFirstWithoutNext({
    required int since,
    required FeedType feedType,
    FeedModifier? feedModifier,
  }) async {
    final firstWithoutNext = await (select(db.seenEventsTable)
          ..where((tbl) => tbl.feedType.equalsValue(feedType))
          ..where(
            (tbl) => feedModifier == null
                ? tbl.feedModifier.isNull()
                : tbl.feedModifier.equalsValue(feedModifier),
          )
          ..where((tbl) => tbl.nextEventReference.isNull())
          ..where((tbl) => tbl.createdAt.isSmallerThanValue(since.toMicroseconds))
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
    return firstWithoutNext;
  }

  Future<List<SeenEvent>> getEventsExcluding({
    required FeedType feedType,
    required List<EventReference> exclude,
    required int limit,
    int? since,
    int? until,
    FeedModifier? feedModifier,
  }) async {
    final query = select(db.seenEventsTable)
      ..where((tbl) => tbl.feedType.equalsValue(feedType))
      ..where(
        (tbl) => feedModifier == null
            ? tbl.feedModifier.isNull()
            : tbl.feedModifier.equalsValue(feedModifier),
      )
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(limit);
    if (exclude.isNotEmpty) {
      query.where((tbl) => tbl.eventReference.isNotInValues(exclude));
    }
    if (since != null) {
      query.where((tbl) => tbl.createdAt.isBiggerThanValue(since.toMicroseconds));
    }
    if (until != null) {
      query.where((tbl) => tbl.createdAt.isSmallerThanValue(until.toMicroseconds));
    }
    return query.get();
  }

  Future<void> deleteEvents({
    required FeedType feedType,
    required List<String> retainPubkeys,
    required int until,
    FeedModifier? feedModifier,
  }) async {
    final query = delete(db.seenEventsTable)
      ..where((tbl) => tbl.feedType.equalsValue(feedType))
      ..where(
        (tbl) => feedModifier == null
            ? tbl.feedModifier.isNull()
            : tbl.feedModifier.equalsValue(feedModifier),
      )
      ..where(
        (tbl) => Expression.or([
          tbl.createdAt.isSmallerThanValue(until.toMicroseconds),
          tbl.pubkey.isNotIn(retainPubkeys),
        ]),
      );
    await query.go();
  }
}
