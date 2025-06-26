// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/dao/seen_reposts_dao.d.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seen_reposts_dao_provider.r.g.dart';

@Riverpod(keepAlive: true)
SeenRepostsDao seenRepostsDao(Ref ref) =>
    SeenRepostsDao(db: ref.watch(followingFeedDatabaseProvider));
