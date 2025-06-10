// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/converters/feed_modifier_converter.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/converters/feed_type_converter.c.dart';
import 'package:ion/app/features/feed/data/database/following_feed_database/tables/seen_events_table.c.dart';
import 'package:ion/app/features/feed/data/models/feed_modifier.dart';
import 'package:ion/app/features/feed/data/models/feed_type.dart';
import 'package:ion/app/features/ion_connect/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'following_feed_database.c.g.dart';

@Riverpod(keepAlive: true)
FollowingFeedDatabase followingFeedDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = FollowingFeedDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}

@DriftDatabase(
  tables: [
    SeenEventsTable,
  ],
)
class FollowingFeedDatabase extends _$FollowingFeedDatabase {
  FollowingFeedDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'following_feed_database_$pubkey');
  }
}
