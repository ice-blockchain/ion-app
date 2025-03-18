// SPDX-License-Identifier: ice License 1.0

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ion/app/exceptions/exceptions.dart';
import 'package:ion/app/features/auth/providers/auth_provider.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/converters/event_reference_converter.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/notifications_database.c.steps.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/comments_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/followers_table.c.dart';
import 'package:ion/app/features/feed/notifications/data/database/tables/likes_table.c.dart';
import 'package:ion/app/features/ion_connect/model/event_reference.c.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_database.c.g.dart';

@Riverpod(keepAlive: true)
NotificationsDatabase notificationsDatabase(Ref ref) {
  final pubkey = ref.watch(currentPubkeySelectorProvider);

  if (pubkey == null) {
    throw UserMasterPubkeyNotFoundException();
  }

  final database = NotificationsDatabase(pubkey);

  onLogout(ref, database.close);

  return database;
}

@DriftDatabase(
  tables: [
    CommentsTable,
    LikesTable,
    FollowersTable,
  ],
  queries: {
    'aggregatedLikes': '''
      WITH DailyLikes AS (
          SELECT
              DATE(datetime(created_at, 'unixepoch', 'localtime')) AS event_date,
              event_id,
              pubkey,
              created_at,
              ROW_NUMBER() OVER (PARTITION BY DATE(datetime(created_at, 'unixepoch', 'localtime')), event_id 
                  ORDER BY created_at DESC) AS rn
          FROM
              likes_table
      )
      SELECT
          event_date,
          event_id,
          GROUP_CONCAT(CASE WHEN rn <= 10 THEN pubkey END, ',') AS latest_pubkeys,
          COUNT(DISTINCT pubkey) AS unique_pubkey_count
      FROM
          DailyLikes
      GROUP BY
          event_date, event_id
      ORDER BY
          event_date DESC, event_id DESC;
    ''',
  },
)
class NotificationsDatabase extends _$NotificationsDatabase {
  NotificationsDatabase(this.pubkey) : super(_openConnection(pubkey));

  final String pubkey;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await Future.wait([
            m.createTable(schema.followersTable),
            m.createTable(schema.likesTable),
          ]);
        },
      ),
    );
  }

  static QueryExecutor _openConnection(String pubkey) {
    return driftDatabase(name: 'notifications_database_$pubkey');
  }
}
