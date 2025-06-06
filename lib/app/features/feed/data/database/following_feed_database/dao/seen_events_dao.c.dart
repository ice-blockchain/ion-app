// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/seen_events_table.c.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seen_events_dao.c.g.dart';

@Riverpod(keepAlive: true)
SeenEventsDao seenEventsDao(Ref ref) => SeenEventsDao(db: ref.watch(followingFeedDatabaseProvider));

@DriftAccessor(tables: [SeenEventsTable])
class SeenEventsDao extends DatabaseAccessor<FollowingFeedDatabase> with _$SeenEventsDaoMixin {
  SeenEventsDao({required FollowingFeedDatabase db}) : super(db);

  Future<void> insert(SeenEvent event) async {
    await into(db.seenEventsTable).insert(event, mode: InsertMode.insertOrReplace);
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
  /// the first next event starting [since] for provided [feedType] + [feedModifier]
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
          ..where((tbl) => tbl.createdAt.isSmallerOrEqualValue(since))
          ..orderBy([
            (tbl) => OrderingTerm(expression: tbl.createdAt),
          ])
          ..limit(1))
        .getSingleOrNull();
    return firstWithoutNext;
  }
}
