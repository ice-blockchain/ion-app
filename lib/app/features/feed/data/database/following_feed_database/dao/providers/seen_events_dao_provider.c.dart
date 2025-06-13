// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/dao/seen_events_dao.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seen_events_dao_provider.c.g.dart';

@Riverpod(keepAlive: true)
SeenEventsDao seenEventsDao(Ref ref) => SeenEventsDao(db: ref.watch(followingFeedDatabaseProvider));
