// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/seen_reposts_table.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seen_reposts_dao.c.g.dart';

@Riverpod(keepAlive: true)
SeenRepostsDao seenRepostsDao(Ref ref) =>
    SeenRepostsDao(db: ref.watch(followingFeedDatabaseProvider));

@DriftAccessor(tables: [SeenRepostsTable])
class SeenRepostsDao extends DatabaseAccessor<FollowingFeedDatabase> with _$SeenRepostsDaoMixin {
  SeenRepostsDao({required FollowingFeedDatabase db}) : super(db);

  Future<void> insert(SeenRepost repost) async {
    await into(db.seenRepostsTable).insert(repost, mode: InsertMode.insertOrReplace);
  }
}
