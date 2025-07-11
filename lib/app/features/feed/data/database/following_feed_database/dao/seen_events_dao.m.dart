// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/extensions/extensions.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/converters/feed_modifier_converter.d.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.m.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/seen_events_table.d.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seen_events_dao.m.g.dart';

@DriftAccessor(tables: [SeenEventsTable])
class SeenEventsDao extends DatabaseAccessor<FollowingFeedDatabase> with _$SeenEventsDaoMixin {
  SeenEventsDao({required FollowingFeedDatabase db}) : super(db);

  Future<void> insert(SeenEvent event) async {
    await into(seenEventsTable).insert(
      SeenEventsTableCompanion.insert(
        feedType: event.feedType,
        feedModifier: event.feedModifier,
        eventReference: event.eventReference,
        nextEventReference: Value(event.nextEventReference),
        pubkey: event.pubkey,
        createdAt: event.createdAt.toMicroseconds,
      ),
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
        (tbl) => tbl.feedModifier.equals(const FeedModifierConverter().toSql(feedModifier)),
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
        (tbl) => tbl.feedModifier.equals(const FeedModifierConverter().toSql(feedModifier)),
      );

    return query.getSingleOrNull();
  }

  Stream<List<SeenEvent>> watchByReferences({
    required Iterable<EventReference> eventsReferences,
  }) {
    final query = select(db.seenEventsTable)
      ..where((tbl) => tbl.eventReference.isInValues(eventsReferences));

    return query.watch();
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
            (tbl) => tbl.feedModifier.equals(const FeedModifierConverter().toSql(feedModifier)),
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

  Future<List<SeenEvent>> getEvents({
    required FeedType feedType,
    required int limit,
    List<EventReference>? excludeReferences,
    List<String>? excludePubkeys,
    int? since,
    int? until,
    FeedModifier? feedModifier,
  }) async {
    final query = select(db.seenEventsTable)
      ..where((tbl) => tbl.feedType.equalsValue(feedType))
      ..where((tbl) => tbl.feedModifier.equals(const FeedModifierConverter().toSql(feedModifier)))
      ..orderBy([
        (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ])
      ..limit(limit);
    if (excludeReferences != null && excludeReferences.isNotEmpty) {
      query.where((tbl) => tbl.eventReference.isNotInValues(excludeReferences));
    }
    if (excludePubkeys != null && excludePubkeys.isNotEmpty) {
      query.where((tbl) => tbl.pubkey.isNotIn(excludePubkeys));
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
        (tbl) => tbl.feedModifier.equals(const FeedModifierConverter().toSql(feedModifier)),
      )
      ..where(
        (tbl) => Expression.or([
          tbl.createdAt.isSmallerThanValue(until.toMicroseconds),
          tbl.pubkey.isNotIn(retainPubkeys),
        ]),
      );
    await query.go();
  }

  Future<Map<String, List<int>>> getUsersCreatedContentTime({
    required int maxUserEvents,
  }) async {
    final result = await db.getEventCreatedAts(maxUserEvents).get();

    final grouped = <String, List<int>>{};

    for (final row in result) {
      grouped.putIfAbsent(row.pubkey, () => []).add(row.createdAt);
    }

    return grouped;
  }
}

@Riverpod(keepAlive: true)
SeenEventsDao seenEventsDao(Ref ref) => SeenEventsDao(db: ref.watch(followingFeedDatabaseProvider));
