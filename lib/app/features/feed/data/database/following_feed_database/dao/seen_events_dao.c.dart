// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/seen_events_table.c.dart';
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
}
