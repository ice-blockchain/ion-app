// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.m.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/seen_reposts_table.d.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.f.dart';

part 'seen_reposts_dao.d.g.dart';

@DriftAccessor(tables: [SeenRepostsTable])
class SeenRepostsDao extends DatabaseAccessor<FollowingFeedDatabase> with _$SeenRepostsDaoMixin {
  SeenRepostsDao({required FollowingFeedDatabase db}) : super(db);

  Future<void> insert(SeenRepost repost) async {
    await into(db.seenRepostsTable).insert(repost, mode: InsertMode.insertOrReplace);
  }

  Future<SeenRepost?> getByRepostedReference(EventReference eventReference) {
    return (select(db.seenRepostsTable)
          ..where(
            (tbl) => tbl.repostedEventReference.equalsValue(eventReference),
          ))
        .getSingleOrNull();
  }
}
