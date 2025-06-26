// SPDX-License-Identifier: ice License 1.0

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/dao/seen_events_dao.d.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/following_feed_database.m.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'seen_events_dao_provider.r.g.dart';

@Riverpod(keepAlive: true)
SeenEventsDao seenEventsDao(Ref ref) => SeenEventsDao(db: ref.watch(followingFeedDatabaseProvider));
